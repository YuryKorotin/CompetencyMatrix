import 'dart:collection';

import 'package:competency_matrix/net/models/knowledge_item.dart';
import 'package:competency_matrix/net/models/knowledge_level.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';

class MatrixStatistics {
  var _matrixId;
  MatrixRepository matrixRepository;

  MatrixStatistics(BigInt matrixId) {
    this._matrixId = matrixId;
    matrixRepository = MatrixRepository();
  }

  Future<HashMap<String, int>> getLevelsStatistics() async {
    var matrixDescription = await matrixRepository.loadSingle(this._matrixId);
    var items = matrixDescription.items;

    var statistics = HashMap<String, int>();
    statistics[Consts.BASE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SIMPLE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SERIOUS_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.COMPLEX_KNOWLEDGE_LEVEL] = 0;

    for (KnowledgeItem item in items) {
      var levels = item.levels;
      var lastName = levels.first.name;
      for (KnowledgeLevel level in levels) {
        if (level.isChecked) {
          lastName = level.name;
        }
      }
      statistics[lastName] += 1;
    }
    return statistics;
  }


}