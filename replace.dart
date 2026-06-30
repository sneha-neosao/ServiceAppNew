import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();
  
  final regex1 = RegExp(r'bool\s+isOnline\s*=\s*await\s+NetworkInfo\(\)\.checkIsConnected;');
  print('Matches for regex1: ' + regex1.allMatches(content).length.toString());
  
  final regex2 = RegExp(r'bool\s+isOnline\s*=\s*await\s+NetworkInfo\(\)\.checkIsConnected;\s*if\s*\(!isOnline\)\s*\{\s*setState\(\(\)\s*\{\s*_isSavingOffline\s*=\s*true;\s*\}\);');
  print('Matches for regex2: ' + regex2.allMatches(content).length.toString());

  final regex3 = RegExp(r'bool\s+isOnline\s*=\s*await\s+NetworkInfo\(\)\.checkIsConnected;\s*if\s*\(!isOnline\)\s*\{\s*setState\(\(\)\s*\{\s*_isSavingOffline\s*=\s*true;\s*\}\);\s*await\s+Future\.delayed\(const\s+Duration\(milliseconds:\s*500\)\);');
  print('Matches for regex3: ' + regex3.allMatches(content).length.toString());

  final regex4 = RegExp(r'bool\s+isOnline\s*=\s*await\s+NetworkInfo\(\)\.checkIsConnected;\s*if\s*\(!isOnline\)\s*\{\s*setState\(\(\)\s*\{\s*_isSavingOffline\s*=\s*true;\s*\}\);\s*await\s+Future\.delayed\(const\s+Duration\(milliseconds:\s*500\)\);\s*await\s+OfflineCommissioningDb\.instance\.saveStep');
  print('Matches for regex4: ' + regex4.allMatches(content).length.toString());
}
