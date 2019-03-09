import 'package:shared_preferences/shared_preferences.dart';

class MatrixPreferences {
  final String _kLevelsPrefs = "levels";

  Future<List<BigInt>> getChosenLevels(BigInt matrixId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<BigInt> chosenLevels = List<BigInt>();

    List<String> levels =
        prefs.getStringList(_kLevelsPrefs + matrixId.toString()) ?? List<String>();
    levels.forEach((element) {
      chosenLevels.add(BigInt.from(int.tryParse(element) ?? 0));
    });
    
    
    return prefs.getStringList(_kLevelsPrefs) ?? List<BigInt>();
  }

  Future<bool> addLevel(BigInt value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> levels = prefs.getStringList(_kLevelsPrefs) ?? List<String>();

    levels.add(value.toString());

    return prefs.setStringList(_kLevelsPrefs, levels);
  }
  Future<bool> removeLevel(BigInt value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> levels = prefs.getStringList(_kLevelsPrefs) ?? List<String>();

    levels.remove(value.toString());

    return prefs.setStringList(_kLevelsPrefs, levels);
  }
}