import 'package:equatable/equatable.dart';
import 'package:fiscal_noir/modules/dashboard/domain/entities/expense_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<ExpenseEntity> expenses;
  final double totalAmount;

  const DashboardLoaded(this.expenses)
      : totalAmount = expenses.fold(0, (sum, item) => sum + item.amount);

  @override
  List<Object?> get props => [expenses, totalAmount];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
