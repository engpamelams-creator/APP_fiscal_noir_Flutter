import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/core/errors/auth_failure.dart';
import 'package:fiscal_noir/modules/auth/domain/entities/user_entity.dart';
import 'package:fiscal_noir/modules/auth/domain/repositories/auth_repository.dart';
import 'package:fiscal_noir/modules/auth/infra/datasources/auth_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.login(email, password);
      return Right(user);
    } catch (e) {
      if (e.toString().contains('Invalid Credentials')) {
        return const Left(InvalidCredentialsFailure());
      }
      return Left(AuthServerFailure(e.toString()));
    }
  }
}
