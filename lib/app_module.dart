import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  Uuid get uuid => const Uuid();
}
