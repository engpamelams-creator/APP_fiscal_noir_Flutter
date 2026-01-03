import 'package:flutter/material.dart';
import 'package:fiscal_noir/core/config/injection.dart';
import 'package:fiscal_noir/modules/auth/presentation/pages/login_page.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const FiscalNoirApp());
}

class FiscalNoirApp extends StatelessWidget {
  const FiscalNoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fiscal Noir',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
