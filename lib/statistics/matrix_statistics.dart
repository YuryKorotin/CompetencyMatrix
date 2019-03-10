import 'dart:collection';

import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';

class MatrixStatistics {
  var _matrixId;
  MatrixRepository matrixRepository;
  MatrixPreferences matrixPreferences;

  MatrixStatistics(BigInt matrixId) {
    this._matrixId = matrixId;
  }

  HashMap<String, int> getLevelsStatistics() {

  }

}