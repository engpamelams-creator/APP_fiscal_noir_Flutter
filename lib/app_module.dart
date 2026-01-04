import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
