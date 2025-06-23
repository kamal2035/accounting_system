import 'package:accounting_system/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class RevenueReportPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> fetchRevenueData() async {
    return await dbHelper.fetchRevenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Revenue Report')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRevenueData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No revenue data found.'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text('Branch')),
                DataColumn(label: Text('Revenue')),
              ],
              rows: data.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['branch_name'])),
                    DataCell(Text('\$${item['revenue']}')),
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
          await dbHelper.insertRevenue('Test Branch', 10000.0);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Revenue added!')));
        },
      ),
    );
  }
}
