import 'dart:io';

void main() {
  final file = File(r"d:\SnehaJadhav\service_app\lib\src\features\home\presentation\pages\home_screen.dart");
  var content = file.readAsStringSync();

  // 1. Add import for amc_workflow_screen.dart
  final importStatement = "import 'package:service_app/src/features/amc/presentation/pages/amc_workflow_screen.dart';\n";
  final lastImportIdx = content.lastIndexOf("import '");
  final endOfLastImport = content.indexOf("\n", lastImportIdx) + 1;
  content = content.substring(0, endOfLastImport) + importStatement + content.substring(endOfLastImport);

  // 2. Remove _AmcViewState enum
  final enumRegex = RegExp(r'enum _AmcViewState \{ dashboard, schedule, details, createReport \}\s*');
  content = content.replaceAll(enumRegex, '');

  // 3. Remove _AmcViewState _amcViewState and related state variables
  final amcStateVarsRegex = RegExp(
    r'_AmcViewState _amcViewState = _AmcViewState\.dashboard;\s*'
    r'int _amcReportsCreated = 0;\s*'
    r'// Selected AMC Item Data\s*'
    r'String\? _selectedAmcTitle;\s*'
    r'String\? _selectedAmcLocation;\s*'
    r'String\? _selectedAmcVisitInfo;\s*'
    r'String\? _selectedAmcWindow;\s*'
  );
  content = content.replaceAll(amcStateVarsRegex, '');

  // 4. Update _onTabTapped to not reset amc states
  final onTabTappedRegex = RegExp(r'void _onTabTapped\(int index\) \{\s*setState\(\(\) \{\s*_selectedIndex = index;\s*_amcViewState = _AmcViewState\.dashboard;\s*_amcReportsCreated = 0;\s*_showCreateReport = false;\s*_showSystemBars = true;\s*\}\);\s*\}');
  final newOnTabTapped = '''void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showCreateReport = false;
      _showSystemBars = true;
    });
  }''';
  content = content.replaceAll(onTabTappedRegex, newOnTabTapped);

  // 5. Update PopScope in build
  final popScopeRegex = RegExp(
    r'return PopScope\(\s*'
    r'canPop: _selectedIndex == 0 && _amcViewState == _AmcViewState\.dashboard,\s*'
    r'onPopInvokedWithResult: \(didPop, result\) \{\s*'
    r'if \(didPop\) return;\s*'
    r'if \(_selectedIndex != 0\) \{\s*'
    r'setState\(\(\) \{\s*'
    r'_selectedIndex = 0;\s*'
    r'_amcViewState = _AmcViewState\.dashboard;\s*'
    r'_amcReportsCreated = 0;\s*'
    r'_showCreateReport = false;\s*'
    r'_showSystemBars = true;\s*'
    r'\}\);\s*'
    r'\} else if \(_amcViewState != _AmcViewState\.dashboard\) \{\s*'
    r'setState\(\(\) \{\s*'
    r'if \(_amcViewState == _AmcViewState\.createReport\) \{\s*'
    r'_amcViewState = _AmcViewState\.details;\s*'
    r'\} else if \(_amcViewState == _AmcViewState\.details\) \{\s*'
    r'_amcViewState = _AmcViewState\.schedule;\s*'
    r'\} else \{\s*'
    r'_amcViewState = _AmcViewState\.dashboard;\s*'
    r'\}\s*'
    r'\}\);\s*'
    r'\}\s*'
    r'\},'
  );
  
  final newPopScope = '''return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
            _showCreateReport = false;
            _showSystemBars = true;
          });
        }
      },''';
  content = content.replaceFirst(popScopeRegex, newPopScope);

  // 6. Remove _amcViewState, _amcReportsCreated etc from the FAB onTap
  final fabOnTapRegex = RegExp(
    r'setState\(\(\) \{\s*'
    r'_selectedIndex = 0;\s*'
    r'_amcViewState = _AmcViewState\.dashboard;\s*'
    r'_amcReportsCreated = 0;\s*'
    r'_showCreateReport = false;\s*'
    r'_showSystemBars = true;\s*'
    r'\}\);'
  );
  final newFabOnTap = '''setState(() {
                                    _selectedIndex = 0;
                                    _showCreateReport = false;
                                    _showSystemBars = true;
                                  });''';
  content = content.replaceAll(fabOnTapRegex, newFabOnTap);

  // 7. Remove _buildHomeTab and update _buildCurrentView to use _buildHomeBody directly
  final buildHomeTabRegex = RegExp(
    r'Widget _buildHomeTab\(\) \{\s*'
    r'switch \(_amcViewState\) \{\s*'
    r'case _AmcViewState\.details:\s*'
    r'return AmcVisitDetailsScreen\([\s\S]*?case _AmcViewState\.dashboard:\s*'
    r'return _buildHomeBody\(\);\s*'
    r'\}\s*'
    r'\}'
  );
  content = content.replaceAll(buildHomeTabRegex, '');

  final buildCurrentViewRegex = RegExp(
    r'case 0:\s*'
    r'child = _buildHomeTab\(\);\s*'
    r'break;'
  );
  content = content.replaceFirst(buildCurrentViewRegex, 'case 0:\n        child = _buildHomeBody();\n        break;');

  // 8. Update UpcomingAmcCard onScheduleTap
  final amcCardRegex = RegExp(
    r'UpcomingAmcCard\(\s*'
    r'upcomingAmcBloc: _upcomingAmcBloc,\s*'
    r'onScheduleTap: \(\) => setState\(\s*'
    r'\(\) => _amcViewState = _AmcViewState\.schedule,\s*'
    r'\),\s*'
    r'\),'
  );
  final newAmcCard = '''UpcomingAmcCard(
            upcomingAmcBloc: _upcomingAmcBloc,
            onScheduleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AmcWorkflowScreen(),
                ),
              );
            },
          ),''';
  content = content.replaceFirst(amcCardRegex, newAmcCard);

  file.writeAsStringSync(content);
  print("Done");
}
