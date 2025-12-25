import 'package:exma/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/enums.dart';
import '../services/expense-service.dart';

class NewTransactionDialog extends StatelessWidget {
  final TransactionType transactionType;
  final String title = '';
  final double amount = 0;

  const NewTransactionDialog({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Transaction',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// What is this for
                const Text(
                  'WHAT IS THIS FOR?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text('e.g. Netflix, Salary'),
                    icon: Icon(Icons.edit_note_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Expense title is required';
                    }
                    return null; // ✅ valid
                  },
                ),

                const SizedBox(height: 20),

                /// Amount
                const Text(
                  'AMOUNT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text('0.00'),
                    icon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Expense amount is required';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Expense amount cannot be less than or equal to 0';
                    }
                    return null; // ✅ valid
                  },
                ),

                const SizedBox(height: 28),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {

                      if(!formKey.currentState!.validate()){
                        return;
                      }

                      var expenseService = ExpenseService();
                      var user = FirebaseAuth.instance.currentUser;
                      var expense = Expense(
                        expenseId: Uuid().v4(),
                        type: transactionType,
                        category: ExpenseCategory.OTHER,
                        amount: double.parse(amountController.text.toString()),
                        timestamp: DateTime.now(),
                        source: ExpenseSource.MANUAL,
                        title: titleController.text.toString(),
                        userId: user!.uid,
                      );
                      await expenseService.saveExpense(expense).then((data) {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Expense added successfully'),
                        ),
                      );
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F5AE6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable Input Field
class _InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _InputField({
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
