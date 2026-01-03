import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String merchantName;
  final double amount;
  final DateTime date;
  final String category;

  const ExpenseEntity({
    required this.id,
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  List<Object?> get props => [id, merchantName, amount, date, category];
}
