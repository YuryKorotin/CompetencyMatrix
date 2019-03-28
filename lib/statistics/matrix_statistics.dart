import 'dart:collection';

import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/net/models/knowledge_item.dart';
import 'package:competency_matrix/net/models/knowledge_level.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/utils/consts.dart';

class MatrixStatistics {
  var _matrixId;
  MatrixRepository matrixRepository;
  MatrixRepositoryDb matrixDbRepository;

  MatrixStatistics(BigInt matrixId) {
    this._matrixId = matrixId;
    matrixRepository = MatrixRepository();
    matrixDbRepository = MatrixRepositoryDb();
  }

  Future<HashMap<String, int>> getLevelsStatistics() async {
    var matrixDescription = await matrixRepository.loadSingle(this._matrixId);
    var items = matrixDescription.matrixDetail.items;

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

  Future<HashMap<String, int>> getLevelsStatisticsForDb() async {
    var matrixDescription = await matrixDbRepository.getMatrix(this._matrixId);
    var items = matrixDescription.knowledgeDbItems;

    var statistics = HashMap<String, int>();
    statistics[Consts.BASE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SIMPLE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SERIOUS_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.COMPLEX_KNOWLEDGE_LEVEL] = 0;

    for (KnowledgeItemDb item in items) {
      var levels = item.levelDbItems;
      var lastName = levels.first.name;
      for (LevelDb level in levels) {
        if (level.isChecked) {
          lastName = level.name;
        }
      }
      statistics[lastName] += 1;
    }
    return statistics;
  }

  Future<int> getMatrixProgress() async {
    var matrixDescription = await matrixRepository.loadSingle(this._matrixId);
    var items = matrixDescription.matrixDetail.items;

    //Progress is taken only for serious level
    var progress = 0;
    var levelToCount = Consts.COMPLEX_KNOWLEDGE_LEVEL;
    int itemsCount = 0;
    var completedLevels = 0;

    for (KnowledgeItem item in items) {
      itemsCount++;
      var levels = item.levels;
      for (KnowledgeLevel level in levels) {
        if (level.isChecked && level.name == levelToCount) {
          completedLevels++;
        }
      }
    }
    progress = (completedLevels / itemsCount * 100).round();
    return progress;
  }
}