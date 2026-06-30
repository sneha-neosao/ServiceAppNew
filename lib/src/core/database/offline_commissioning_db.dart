import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineCommissioningDb {
  static final OfflineCommissioningDb instance = OfflineCommissioningDb._init();
  static Database? _database;

  OfflineCommissioningDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('offline_reports.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE commissioning_report ADD COLUMN step_synced INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE commissioning_report (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        commissioning_work_id TEXT NOT NULL,
        report_id TEXT NOT NULL,
        assign_id TEXT,
        step1 TEXT,
        step2 TEXT,
        step3 TEXT,
        step4 TEXT,
        step5 TEXT,
        step6 TEXT,
        synced INTEGER DEFAULT 0,
        step_synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> updateAssignId(String reportId, String assignId) async {
    final db = await instance.database;
    await db.update(
      'commissioning_report',
      {'assign_id': assignId},
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }

  Future<void> saveStep(String reportId, String commissioningWorkId, int step, Map<String, dynamic> data) async {
    final db = await instance.database;

    final existingReport = await db.query(
      'commissioning_report',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );

    if (existingReport.isEmpty) {
      await db.insert(
        'commissioning_report',
        {
          'report_id': reportId,
          'commissioning_work_id': commissioningWorkId,
          'step$step': jsonEncode(data),
          'synced': 0,
        },
      );
    } else {
      await db.update(
        'commissioning_report',
        {
          'step$step': jsonEncode(data),
        },
        where: 'report_id = ?',
        whereArgs: [reportId],
      );
    }
  }

  Future<Map<String, dynamic>?> getReport(String reportId) async {
    final db = await instance.database;
    final maps = await db.query(
      'commissioning_report',
      columns: ['id', 'commissioning_work_id', 'report_id', 'step1', 'step2', 'step3', 'step4', 'step5', 'step6', 'synced', 'assign_id'],
      where: 'report_id = ?',
      whereArgs: [reportId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllOfflineReports() async {
    final db = await instance.database;
    return await db.query('commissioning_report');
  }

  Future<void> updateSyncedStatus(String reportId, bool isSynced) async {
    final db = await instance.database;
    await db.update(
      'commissioning_report',
      {'synced': isSynced ? 1 : 0},
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }

  Future<void> deleteReport(String reportId) async {
    final db = await instance.database;
    await db.delete(
      'commissioning_report',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }
}
