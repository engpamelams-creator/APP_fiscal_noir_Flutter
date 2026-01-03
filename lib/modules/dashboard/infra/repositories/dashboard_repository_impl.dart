import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fiscal_noir/core/errors/failure.dart';
import 'package:fiscal_noir/modules/dashboard/domain/entities/expense_entity.dart';
import 'package:fiscal_noir/modules/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fiscal_noir/modules/dashboard/infra/datasources/dashboard_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource _dataSource;

  DashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses() async {
    try {
      final expenses = await _dataSource.getExpenses();
      return Right(expenses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
