import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();

  content = content.replaceFirst(
    '"workPhotosPaths": workPhotosPaths,',
    '"workPhotosPaths": _workPhotos.map((f) => f.path).toList(),'
  );

  file.writeAsStringSync(content);
  print('Fixed workPhotosPaths error!');
}
