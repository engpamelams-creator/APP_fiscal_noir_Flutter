import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:fiscal_noir/modules/auth/domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signUp(String email, String password);
}

// @LazySingleton(as: AuthDataSource) -> Disabled in favor of Firebase impl
class MockAuthDataSource implements AuthDataSource {
  final Uuid uuid;

  MockAuthDataSource(this.uuid);

  @override
  Future<UserEntity> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network

    if (email == 'admin@noir.com' && password == '123456') {
      return UserEntity(
        id: uuid.v4(),
        name: 'Senior Architect',
        email: email,
      );
    } else {
      throw Exception('Invalid Credentials');
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserEntity(id: uuid.v4(), name: 'New User', email: email);
  }
}
