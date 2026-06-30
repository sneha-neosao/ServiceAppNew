import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineServiceWorkDb {
  static final OfflineServiceWorkDb instance = OfflineServiceWorkDb._init();
  static Database? _database;

  OfflineServiceWorkDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('offline_service_work.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE service_work_report (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        report_id TEXT NOT NULL,
        assign_id TEXT
      )
    ''');
  }

  Future<void> saveAssignId(String reportId, String assignId) async {
    final db = await instance.database;
    
    final existingReport = await db.query(
      'service_work_report',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );

    if (existingReport.isEmpty) {
      await db.insert(
        'service_work_report',
        {
          'report_id': reportId,
          'assign_id': assignId,
        },
      );
    } else {
      await db.update(
        'service_work_report',
        {'assign_id': assignId},
        where: 'report_id = ?',
        whereArgs: [reportId],
      );
    }
  }

  Future<String?> getAssignId(String reportId) async {
    final db = await instance.database;
    final maps = await db.query(
      'service_work_report',
      columns: ['assign_id'],
      where: 'report_id = ?',
      whereArgs: [reportId],
    );

    if (maps.isNotEmpty) {
      return maps.first['assign_id'] as String?;
    } else {
      return null;
    }
  }
}
