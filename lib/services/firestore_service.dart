import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiscal_noir/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final CollectionReference _transactionsRef =
      FirebaseFirestore.instance.collection('transactions');

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactionsRef.add(transaction.toMap());
      debugPrint("Transaction Added to Firestore");
    } catch (e) {
      debugPrint("Error adding transaction: $e");
      rethrow;
    }
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionsRef.doc(id).delete();
      debugPrint("Transaction Deleted from Firestore");
    } catch (e) {
      debugPrint("Error deleting transaction: $e");
      rethrow;
    }
  }
}
