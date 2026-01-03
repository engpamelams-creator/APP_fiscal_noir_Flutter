import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cubit = GetIt.I<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit, // Provide the injected cubit
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red.shade900),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Welcome, ${state.user.name}'),
                    backgroundColor: AppTheme.white),
              );
              // Navigate to dashboard here later
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ScannerPage()),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FISCAL\nNOIR',
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 64),
                  NoirInput(
                    hint: 'IDENTIFIER',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  NoirInput(
                    hint: 'ACCESS KEY',
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 32),
                  NoirButton(
                    label: 'AUTHENTICATE',
                    isLoading: isLoading,
                    onTap: () {
                      _cubit.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
