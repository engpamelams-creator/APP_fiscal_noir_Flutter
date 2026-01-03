import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/core/shared/noir_button.dart';
import 'package:fiscal_noir/core/shared/noir_input.dart';
import 'package:fiscal_noir/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:fiscal_noir/modules/scanner/presentation/pages/scanner_page.dart';
import 'package:fiscal_noir/modules/auth/presentation/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'admin@noir.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  final _cubit = GetIt.I<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Access Granted'),
                    backgroundColor: AppColors.success),
              );
              // Navigate to dashboard here later
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ScannerPage()),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo / Title
                      Text(
                        'FISCAL NOIR',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(48),

                      // Email Input
                      NoirInput(
                        label: 'IDENTITY',
                        icon: Icons.person_outline,
                        controller: _emailController,
                        validator: (value) =>
                            value!.isEmpty ? 'Identity required' : null,
                      ),
                      const Gap(24),

                      // Password Input
                      NoirInput(
                        label: 'PASSPHRASE',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Passphrase required' : null,
                      ),
                      const Gap(48),

                      // Login Button
                      NoirButton(
                        label: 'AUTHENTICATE',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _cubit.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                      ),

                      const Gap(24),
                      Text(
                        'FORBIDDEN ACCESS WILL BE MONITORED',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
