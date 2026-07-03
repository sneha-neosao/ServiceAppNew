import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../network/network_checker.dart';
import 'offline_commissioning_db.dart';

class OfflineAmcReportsDb {
  static final OfflineAmcReportsDb instance = OfflineAmcReportsDb._init();

  OfflineAmcReportsDb._init();

  Future<Database> get database async {
    return await OfflineCommissioningDb.instance.database;
  }

  Future<void> updateAssignId(String commissioningWorkId, String reportId, String assignId) async {
    final db = await database;
    await db.update(
      'amc_reports',
      {
        'assign_id': assignId,
        if (reportId.isNotEmpty) 'report_id': reportId,
      },
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );
  }

  Future<void> updateReportState(String commissioningWorkId, String reportState) async {
    final db = await database;
    await db.update(
      'amc_reports',
      {'report_state': reportState},
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );
  }

  Future<void> saveStep(String reportId, String commissioningWorkId, int step, Map<String, dynamic> data, {String? reportState}) async {
    final db = await database;

    final existingReport = await db.query(
      'amc_reports',
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );

    bool isOnline = await NetworkInfo().checkIsConnected;
    String finalStateToSave = reportState ?? (isOnline ? 'online' : 'offline');

    if (existingReport.isEmpty) {
      await db.insert(
        'amc_reports',
        {
          'report_id': reportId,
          'commissioning_work_id': commissioningWorkId,
          'report_state': finalStateToSave,
          'step$step': jsonEncode(data),
          'synced': 0,
        },
      );
    } else {
      final currentReportState = existingReport.first['report_state'] as String?;
      String stateToSave = currentReportState ?? 'online';
      
      // If any step goes offline, it switches to 'offline' permanently.
      if (finalStateToSave == 'offline') {
        stateToSave = 'offline';
      }

      await db.update(
        'amc_reports',
        {
          'step$step': jsonEncode(data),
          if (reportId.isNotEmpty) 'report_id': reportId,
          'report_state': stateToSave,
        },
        where: 'commissioning_work_id = ?',
        whereArgs: [commissioningWorkId],
      );
    }
  }

  Future<Map<String, dynamic>?> getReport(String reportId) async {
    final db = await database;
    final maps = await db.query(
      'amc_reports',
      columns: ['id', 'commissioning_work_id', 'report_id', 'step1', 'step2', 'step3', 'synced', 'assign_id', 'report_state'],
      where: 'report_id = ?',
      whereArgs: [reportId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getReportByWorkId(String commissioningWorkId) async {
    final db = await database;
    final maps = await db.query(
      'amc_reports',
      columns: ['id', 'commissioning_work_id', 'report_id', 'step1', 'step2', 'step3', 'synced', 'assign_id', 'report_state'],
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<String?> getAssignIdByWorkId(String commissioningWorkId) async {
    final db = await database;
    final maps = await db.query(
      'amc_reports',
      columns: ['assign_id'],
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );
    if (maps.isNotEmpty) {
      return maps.first['assign_id'] as String?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllOfflineReports() async {
    final db = await database;
    return await db.query('amc_reports');
  }

  Future<void> updateSyncedStatus(String reportId, bool isSynced) async {
    final db = await database;
    await db.update(
      'amc_reports',
      {'synced': isSynced ? 1 : 0},
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }

  Future<void> deleteReport(String reportId) async {
    final db = await database;
    await db.delete(
      'amc_reports',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
  }

  Future<int> getInitialStep(String commissioningWorkId) async {
    final db = await database;
    final maps = await db.query(
      'amc_reports',
      columns: ['step1', 'step2'],
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      if (map['step2'] != null) return 3;
      if (map['step1'] != null) return 2;
    }
    return 1;
  }
}
