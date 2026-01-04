import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:fiscal_noir/modules/dashboard/domain/entities/expense_entity.dart';

abstract class DashboardDataSource {
  Future<List<ExpenseEntity>> getExpenses();
}

@LazySingleton(as: DashboardDataSource)
class MockDashboardDataSource implements DashboardDataSource {
  final Uuid uuid;

  MockDashboardDataSource(this.uuid);

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate net

    return [
      ExpenseEntity(
        id: uuid.v4(),
        merchantName: 'Starbucks',
        amount: 24.90,
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        category: 'Food',
      ),
      ExpenseEntity(
        id: uuid.v4(),
        merchantName: 'Uber',
        amount: 45.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Transport',
      ),
      ExpenseEntity(
        id: uuid.v4(),
        merchantName: 'AWS Bridge',
        amount: 350.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Infrastructure',
      ),
      ExpenseEntity(
        id: uuid.v4(),
        merchantName: 'Apple Store',
        amount: 8900.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Electronics',
      ),
    ];
  }
}
