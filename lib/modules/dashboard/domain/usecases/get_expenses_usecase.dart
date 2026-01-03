import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/dashboard/domain/entities/expense_entity.dart';
import 'package:fiscal_noir/modules/dashboard/domain/repositories/dashboard_repository.dart';

@injectable
class GetExpensesUseCase {
  final DashboardRepository _repository;

  GetExpensesUseCase(this._repository);

  Future<Either<Failure, List<ExpenseEntity>>> call() async {
    return _repository.getExpenses();
  }
}
