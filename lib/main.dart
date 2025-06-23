import 'package:accounting_system/expenses_report_page.dart';
import 'package:accounting_system/users_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'branches_page.dart';
import 'users_page.dart';
import 'reports_page.dart'; // استيراد صفحة التقارير
import 'revenue_report_page.dart'; // استيراد صفحة تقرير الإيرادات
import 'warehouses_page.dart'; //استيراد صفحة ادارة المخازن
import 'register_page.dart'; // استيراد صفحة التسجيل

void main() {
  runApp(AccountingSystemApp());
}

class AccountingSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accounting System',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(), // <--- إضافة هذا السطر
        '/dashboard': (context) => DashboardPage(),
        '/branches': (context) => BranchesPage(),
        '/users': (context) => UsersPage(),
        '/reports': (context) => ReportsPage(),
        '/revenue-report': (context) => RevenueReportPage(),
        '/warehouses': (context) => WarehousesPage(),
        '/settings': (context) =>
            Scaffold(body: Center(child: Text('Settings Page'))),
        '/expenses-report': (context) => ExpensesReportPage(),
      },
    );
  }
}
