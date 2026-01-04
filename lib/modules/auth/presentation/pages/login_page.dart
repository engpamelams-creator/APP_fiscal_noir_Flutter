import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:fiscal_noir/modules/main/presentation/pages/main_page.dart';
import 'package:fiscal_noir/modules/auth/presentation/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _cubit = GetIt.I<AuthCubit>();
  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        _cubit.login(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        _cubit.signUp(
          _emailController.text,
          _passwordController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit, // Use value since it's injected singleton-ish
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Background Image with Overlay
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),

            // 2. Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    } else if (state is AuthSuccess) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainPage()),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/icon.png',
                            height: 100,
                          ),
                          const Gap(16),
                          Text(
                            'FISCAL NOIR',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(60),

                          // Name Field (SignUp Only)
                          if (!_isLogin) ...[
                            _buildTextField(
                              controller: _nameController,
                              label: 'Nome Completo',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? 'Nome necessário' : null,
                            ),
                            const Gap(24),
                          ],

                          // Email Field
                          _buildTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            icon: Icons.email_outlined,
                            validator: (v) =>
                                v!.isEmpty ? 'E-mail necessário' : null,
                          ),
                          const Gap(24),

                          // Password Field
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Senha',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: (v) => v!.length < 6
                                ? 'Senha muito curta (min 6)'
                                : null,
                          ),
                          const Gap(48),

                          // Action Button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  (state is AuthLoading) ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: (state is AuthLoading)
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _isLogin ? 'ENTRAR' : 'CADASTRAR',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),

                          const Gap(24),

                          // Toggle Auth Mode
                          TextButton(
                            onPressed: _toggleAuthMode,
                            child: Text(
                              _isLogin
                                  ? 'Não tem conta? Cadastre-se'
                                  : 'Já tem conta? Entre',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const Gap(24),

                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                  child: Divider(color: Colors.white24)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OU",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(color: Colors.white24)),
                            ],
                          ),

                          const Gap(24),

                          // Social Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                  Icons.g_mobiledata), // Mock Google
                              const Gap(24),
                              _buildSocialButton(Icons.apple), // Mock Apple
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: InkWell(
        onTap: () {}, // Mock
        borderRadius: BorderRadius.circular(25),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
