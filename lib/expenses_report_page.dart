import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class ExpensesReportPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> fetchExpenseData() async {
    return await dbHelper.fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses Report')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchExpenseData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense data found.'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text('Branch')),
                DataColumn(label: Text('Expense')),
              ],
              rows: data.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['branch_name'])),
                    DataCell(Text('\$${item['expense']}')),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await dbHelper.insertExpense('Test Branch', 5000.0);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Expense added!')));
        },
      ),
    );
  }
}
