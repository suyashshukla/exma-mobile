import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';
import '../models/enums.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ExpenseService();

  /// ✅ Save or Update Expense
  Future<void> saveExpense(Expense expense) async {
    final user = firebaseAuth.currentUser;

    final updatedExpense = Expense(
      expenseId: expense.expenseId,
      type: expense.type,
      category: expense.category ?? ExpenseCategory.OTHER,
      amount: expense.amount,
      timestamp: expense.timestamp,
      source: expense.source ?? ExpenseSource.MANUAL,
      title: expense.title,
      userId: user?.uid ?? '',
    );

    final expenseRef =
    _firestore.collection('expenses').doc(updatedExpense.expenseId);

    await expenseRef.set(updatedExpense.toJson());
  }

  /// ✅ Remove Expense
  Future<void> removeExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
    await _firestore
        .collection('user-expense-mappings')
        .doc(expenseId)
        .delete();
  }

  /// ✅ Update Expense (same as save)
  Future<void> updateExpense(Expense expense) async {
    await saveExpense(expense);
  }

  /// ✅ Get Expenses For User By Date
  Future<List<Expense>> getExpensesForUser(DateTime date) async {
    final userId = firebaseAuth.currentUser?.uid;

    if (userId == null || userId.isEmpty) {
      return [];
    }

    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('timestamp',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp',
        isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['timestamp'] = (data['timestamp'] as Timestamp).toDate();
      return Expense.fromJson(data);
    }).toList();
  }
}