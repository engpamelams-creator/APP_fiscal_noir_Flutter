import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double value;
  final DateTime date;
  final String status;

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.value,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'value': value,
      'date': Timestamp.fromDate(date),
      'status': status,
    };
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}
