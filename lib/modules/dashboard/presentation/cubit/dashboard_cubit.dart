import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/modules/dashboard/domain/usecases/get_expenses_usecase.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final GetExpensesUseCase _getExpensesUseCase;

  DashboardCubit(this._getExpensesUseCase) : super(DashboardInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(DashboardLoading());
    final result = await _getExpensesUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (expenses) => emit(DashboardLoaded(expenses)),
    );
  }

  void toggleStealthMode() {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(isStealthMode: !currentState.isStealthMode));
    }
  }
}
