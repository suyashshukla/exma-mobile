import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums.dart';

class Expense {
  final String expenseId;
  final TransactionType type;
  final ExpenseCategory category;
  final double amount;
  final DateTime timestamp;
  final ExpenseSource source;
  final String title;

  /// Can be removed if firestore allows relation data retrieval
  final String userId;

  Expense({
    required this.expenseId,
    required this.type,
    required this.category,
    required this.amount,
    required this.timestamp,
    required this.source,
    required this.title,
    required this.userId,
  });

  /// ✅ Factory constructor for Firebase/JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      expenseId: json['expenseId'],
      type: TransactionType.values.byName(json['type']),
      category: ExpenseCategory.values.byName(json['category']),
      amount: (json['amount'] as num).toDouble(),
      timestamp: json['timestamp'],
      source: ExpenseSource.values.byName(json['source']),
      title: json['title'],
      userId: json['userId'],
    );
  }

  /// ✅ Convert back to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'expenseId': expenseId,
      'type': type.name,
      'category': category.name,
      'amount': amount,
      'timestamp':Timestamp.fromDate(timestamp),
      'source': source.name,
      'title': title,
      'userId': userId,
    };
  }
}