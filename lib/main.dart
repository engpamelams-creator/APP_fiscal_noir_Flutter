import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';

import 'package:fiscal_noir/core/config/injection.dart';
import 'package:fiscal_noir/modules/auth/presentation/pages/login_page.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBsxboSvYhj16ewspihj1YRd_RFNGGItZ4",
        authDomain: "fiscalnoir.firebaseapp.com",
        projectId: "fiscalnoir",
        storageBucket: "fiscalnoir.firebasestorage.app",
        messagingSenderId: "836143074856",
        appId: "1:836143074856:web:322bd3d89ba62be2cb2f1d",
        measurementId: "G-RGNPGF82L2",
      ),
    );
  } else {
    // Para Android/iOS usa o arquivo json automático
    await Firebase.initializeApp();
  }
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
