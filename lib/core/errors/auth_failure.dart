import 'package:fiscal_noir/core/errors/failure.dart';

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid Email or Password');
}

class AuthServerFailure extends Failure {
  const AuthServerFailure(super.message);
}
