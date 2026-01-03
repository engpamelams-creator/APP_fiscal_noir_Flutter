import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/auth/domain/entities/user_entity.dart';
import 'package:fiscal_noir/modules/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return _repository.login(email: email, password: password);
  }
}
