import 'dart:io';

void main() {
  final file = File('lib/src/features/offline/presentation/pages/offline_reports_screen.dart');
  String content = file.readAsStringSync();

  content = content.replaceFirst(
    '''                    onTap: synced ? null : () => _syncReport(reportId),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: synced
                            ? Colors.grey[400]
                            : const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            synced ? 'Synced' : 'Sync Report',''',
    '''                    onTap: (synced || stepsCompleted < 6) ? null : () => _syncReport(reportId),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: (synced || stepsCompleted < 6)
                            ? Colors.grey[400]
                            : const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            synced ? 'Synced' : (stepsCompleted < 6 ? 'Incomplete' : 'Sync Report'),'''
  );

  file.writeAsStringSync(content);
  print('Fixed sync report button activity condition!');
}
