import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/modules/auth/domain/usecases/login_usecase.dart';
import 'package:fiscal_noir/modules/auth/presentation/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await _loginUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
