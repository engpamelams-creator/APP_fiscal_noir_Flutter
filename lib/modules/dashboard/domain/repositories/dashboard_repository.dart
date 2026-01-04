import 'package:fpdart/fpdart.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/dashboard/domain/entities/expense_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses();
}
