import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'accounting_system.db');
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _createTables(db);
    }
  }

  // Future<void> _createUsersTable(Database db) async {
  //   await db.execute('''
  //     CREATE TABLE IF NOT EXISTS users (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       name TEXT NOT NULL,
  //       email TEXT NOT NULL UNIQUE,
  //       password TEXT NOT NULL,
  //       role TEXT NOT NULL
  //     )
  //   ''');
  // }

  //  Future<void> _createRevenuesTable(Database db) async {
  //     await db.execute('''
  //       CREATE TABLE IF NOT EXISTS revenues (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         branch_name TEXT NOT NULL,
  //         revenue REAL NOT NULL
  //       )
  //     ''');
  //   }

  //   Future<void> _createExpensesTable(Database db) async {
  //     await db.execute('''
  //       CREATE TABLE IF NOT EXISTS expenses (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         branch_name TEXT NOT NULL,
  //         expense REAL NOT NULL
  //       )
  //     ''');
  //   }

  //   Future<void> _createWarehousesTable(Database db) async {
  //     await db.execute('''
  //       CREATE TABLE IF NOT EXISTS warehouses (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         name TEXT NOT NULL,
  //         location TEXT NOT NULL,
  //         manager_id INTEGER,
  //         phone TEXT,
  //         status TEXT NOT NULL,
  //         FOREIGN KEY (manager_id) REFERENCES users (id)
  //       )
  //     ''');
  //     Future<void> _createPendingUsersTable(Database db) async {
  //       await db.execute('''
  //     CREATE TABLE IF NOT EXISTS pending_users (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       name TEXT NOT NULL,
  //       email TEXT NOT NULL UNIQUE,
  //       password TEXT NOT NULL,
  //       requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  //     )
  //   ''');
  //     }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        branch_name TEXT NOT NULL,
        expense REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE revenues (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        branch_name TEXT NOT NULL,
        revenue REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE warehouses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL
      )
    ''');
  }

  /// دالة جديدة للبحث عن المستخدم بواسطة اسم المستخدم (name)
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// التحقق من بيانات المستخدم إذا كانت صحيحة عند تسجيل الدخول
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// إدخال بيانات المستخدمين
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // إضافة طلب تسجيل جديد
  Future<int> insertPendingUser(Map<String, dynamic> pendingUser) async {
    final db = await database;
    return await db.insert('pending_users', pendingUser);
  }

  // جلب جميع طلبات التسجيل المعلقة
  Future<List<Map<String, dynamic>>> getPendingUsers() async {
    final db = await database;
    return await db.query('pending_users', orderBy: 'requested_at DESC');
  }

  // حذف طلب تسجيل (عند الموافقة أو الرفض)
  Future<int> deletePendingUser(int id) async {
    final db = await database;
    return await db.delete('pending_users', where: 'id = ?', whereArgs: [id]);
  }

  /// جلب بيانات المستخدمين
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  /// إدخال بيانات المخازن(مخزن جديد)
  Future<int> insertWarehouse(Map<String, dynamic> warehouse) async {
    final db = await database;
    return await db.insert('warehouses', warehouse);
  }

  /// جلب بيانات المخازن
  Future<List<Map<String, dynamic>>> getAllWarehouses() async {
    final db = await database;
    return await db.query('warehouses');
  }

  /// تعديل بيانات مخزن
  Future<int> updateWarehouse(int id, Map<String, dynamic> updatedData) async {
    final db = await database;
    return await db.update(
      'warehouses',
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// حذف مخزن
  Future<int> deleteWarehouse(int id) async {
    final db = await database;
    return await db.delete('warehouses', where: 'id = ?', whereArgs: [id]);
  }

  /// إدخال بيانات الإيرادات
  Future<int> insertRevenue(String branchName, double revenue) async {
    final db = await database;
    return await db.insert('revenues', {
      'branch_name': branchName,
      'revenue': revenue,
    });
  }

  /// جلب بيانات الإيرادات
  Future<List<Map<String, dynamic>>> fetchRevenues() async {
    final db = await database;
    return await db.query('revenues');
  }

  /// إدخال بيانات المصروفات
  Future<int> insertExpense(String branchName, double expense) async {
    final db = await database;
    return await db.insert('expenses', {
      'branch_name': branchName,
      'expense': expense,
    });
  }

  /// جلب بيانات المصروفات
  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final db = await database;
    return await db.query('expenses');
  }
}
