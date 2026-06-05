import 'dart:io';

void main() {
  final file = File(r"d:\SnehaJadhav\service_app\lib\src\features\home\presentation\pages\home_screen.dart");
  final lines = file.readAsLinesSync();

  // Search for "// AMC Card"
  int startAmc = -1;
  int endAmc = -1;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim() == '// AMC Card') {
      startAmc = i + 1; // Start replacing from the Container
    }
    if (startAmc != -1 && i > startAmc && lines[i].trim() == '],') {
       // Look for the end of the Column children array.
       if (lines[i+1].trim() == '),' && lines[i+2].trim() == ');') {
         // This is the end of _buildHomeBody
         endAmc = i - 1; // The line before "],"
         break;
       }
    }
  }

  if (startAmc != -1 && endAmc != -1) {
    lines.removeRange(startAmc, endAmc + 1);
    
    // Insert new widget
    final widgetCall = '''
          UpcomingAmcCard(
            upcomingAmcBloc: _upcomingAmcBloc,
            onScheduleTap: () => setState(
              () => _amcViewState = _AmcViewState.schedule,
            ),
          ),''';
    lines.insertAll(startAmc, widgetCall.split('\n'));
    print("Replaced AMC Card Container");
  } else {
    print("Could not find AMC Card Container boundaries");
  }

  file.writeAsStringSync(lines.join('\n'));
  print("Done modifications.");
}
