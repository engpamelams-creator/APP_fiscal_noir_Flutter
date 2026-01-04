import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:fiscal_noir/core/config/injection.dart';
import 'package:fiscal_noir/modules/auth/presentation/pages/login_page.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://example@sentry.io/123'; // Placeholder DSN
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const FiscalNoirApp()),
  );
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
