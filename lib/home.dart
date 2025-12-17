import 'package:exma/models/enums.dart';
import 'package:exma/models/expense.dart';
import 'package:exma/services/expense-service.dart';
import 'package:exma/widgets/expense-tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();
  var user = FirebaseAuth.instance.currentUser;
  var expenseService = ExpenseService();
  List<Expense> expensesAsOnSelectedFrequency = [];
  double totalBalance = 0;

  void _changeDate(int days) {
    var updatedDate = selectedDate.add(Duration(days: days));
    expenseService.getExpensesForUser(selectedDate).then((data) {
      setState(() {
        selectedDate = updatedDate;
        expensesAsOnSelectedFrequency = data;
        setCurrentBalance();
      });
    });
  }

  void setCurrentBalance() {
    for (var item in expensesAsOnSelectedFrequency) {
      totalBalance =
          totalBalance +
          (item.type == TransactionType.CREDIT ? item.amount : -item.amount);
    }
  }

  @override
  void initState() {
    super.initState();
    _changeDate(0);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ HEADER CARD
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // LOGO + LOGOUT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 6),
                            Text(
                              "exma",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout, size: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // GREETING
                    Row(
                      children: [
                        Text(
                          "Hi, ${user?.displayName} 👋",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Text(
                          "Here's your daily overview",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // DATE PICKER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => _changeDate(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          onPressed: () => _changeDate(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // BALANCE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          "₹$totalBalance",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ✅ EMPTY STATE
            Expanded(
              child: expensesAsOnSelectedFrequency.isEmpty
                  ? Column(
                      children: const [
                        Spacer(),
                        Icon(Icons.air_outlined, size: 50, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          "Your expense jar is empty 🌑",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Time to add your first transaction!",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Spacer(),
                      ],
                    )
                  : ListView.builder(
                      itemCount: expensesAsOnSelectedFrequency.length,
                      itemBuilder: (context, index) => TransactionTile(
                        expense: expensesAsOnSelectedFrequency[index],
                      ),
                    ),
            ),
            // ✅ BOTTOM BUTTONS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        print("Add Income");
                      },
                      child: const Text(
                        "+  Income",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        print("Add Expense");
                      },
                      child: const Text(
                        "-  Expense",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
