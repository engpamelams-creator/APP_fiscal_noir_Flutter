import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';

import 'package:fiscal_noir/core/config/injection.dart';
import 'package:fiscal_noir/modules/auth/presentation/pages/login_page.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

class FiscalNoirApp extends StatefulWidget {
  const FiscalNoirApp({super.key});

  @override
  State<FiscalNoirApp> createState() => _FiscalNoirAppState();
}

class _FiscalNoirAppState extends State<FiscalNoirApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialization();
  }

  Future<void> _initialization() async {
    // Pre-cache the heavy background image to avoid flicker
    await precacheImage(
        const AssetImage('assets/images/background.jpg'), context);

    // Remove splash screen once data is ready
    FlutterNativeSplash.remove();
  }

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
