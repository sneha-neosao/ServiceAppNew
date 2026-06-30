import 'dart:io';

void main() {
  final file = File('lib/src/core/database/offline_commissioning_db.dart');
  String content = file.readAsStringSync();

  content = content.replaceFirst(
    '''  Future<void> saveStep(String reportId, String commissioningWorkId, int step, Map<String, dynamic> data) async {
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
          'step\': jsonEncode(data),
          'synced': 0,
        },
      );
    } else {
      await db.update(
        'commissioning_report',
        {
          'step\': jsonEncode(data),
        },
        where: 'report_id = ?',
        whereArgs: [reportId],
      );
    }
  }''',
    '''  Future<void> saveStep(String reportId, String commissioningWorkId, int step, Map<String, dynamic> data) async {
    final db = await instance.database;

    final existingReport = await db.query(
      'commissioning_report',
      where: 'commissioning_work_id = ?',
      whereArgs: [commissioningWorkId],
    );

    if (existingReport.isEmpty) {
      await db.insert(
        'commissioning_report',
        {
          'report_id': reportId,
          'commissioning_work_id': commissioningWorkId,
          'step\': jsonEncode(data),
          'synced': 0,
        },
      );
    } else {
      final existingReportId = existingReport.first['report_id'] as String?;
      String finalReportId = (reportId.isNotEmpty) ? reportId : (existingReportId ?? "");

      await db.update(
        'commissioning_report',
        {
          'report_id': finalReportId,
          'step\': jsonEncode(data),
        },
        where: 'commissioning_work_id = ?',
        whereArgs: [commissioningWorkId],
      );
    }
  }'''
  );

  file.writeAsStringSync(content);
  print('Updated saveStep in offline_commissioning_db.dart');
}
