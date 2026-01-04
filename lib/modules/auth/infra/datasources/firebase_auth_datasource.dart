import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/modules/auth/domain/entities/user_entity.dart';
import 'package:fiscal_noir/modules/auth/infra/datasources/auth_datasource.dart';

@LazySingleton(as: AuthDataSource)
class FirebaseAuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return UserEntity(
        id: user.uid,
        name: user.displayName ?? email,
        email: user.email ?? email,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return UserEntity(
        id: user.uid,
        name: user.displayName ?? email,
        email: user.email ?? email,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
