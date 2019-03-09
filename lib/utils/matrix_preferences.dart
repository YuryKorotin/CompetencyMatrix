import 'package:shared_preferences/shared_preferences.dart';

class MatrixPreferences {

  BigInt _matrixId;
  final String _kLevelsPrefs = "levels";

  MatrixPreferences (BigInt matrixId) {
    _matrixId = matrixId;
  }

  Future<List<String>> getChosenLevels(BigInt matrixId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> chosenLevels = List<String>();

    List<String> levels =
        prefs.getStringList(_matrixId.toString() + _kLevelsPrefs) ?? List<String>();
    levels.forEach((element) {
      chosenLevels.add(element);
    });
    
    
    return chosenLevels;
  }

  Future<bool> addLevel(BigInt value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> levels = prefs.getStringList(_matrixId.toString() + _kLevelsPrefs) ?? List<String>();

    levels.add(value.toString());

    print(levels.length.toString());

    return prefs.setStringList(_matrixId.toString() + _kLevelsPrefs, levels);
  }
  Future<bool> removeLevel(BigInt value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> levels = prefs.getStringList(_matrixId.toString() + _kLevelsPrefs) ?? List<String>();

    levels.remove(value.toString());

    return prefs.setStringList(_matrixId.toString() + _kLevelsPrefs, levels);
  }
}