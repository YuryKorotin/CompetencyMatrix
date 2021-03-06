import 'dart:collection';

import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/entities/knowledge_item_entity.dart';
import 'package:competency_matrix/entities/knowledge_level_enity.dart';
import 'package:competency_matrix/net/models/knowledge_item.dart';
import 'package:competency_matrix/net/models/knowledge_level.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_fire_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/repositories/remote_repository.dart';
import 'package:competency_matrix/utils/consts.dart';

class MatrixStatistics {
  var _matrixId;
  BaseMatrixRepository matrixRepository;
  MatrixRepositoryDb matrixDbRepository;

  MatrixStatistics(BigInt matrixId) {
    this._matrixId = matrixId;
    matrixRepository = MatrixFireRepository(RemoteRepository());
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

    for (KnowledgeItemEntity item in items) {
      var levels = item.levels;
      var lastName = levels.first.name;
      for (KnowledgeLevelEntity level in levels) {
        if (level.isChecked) {
          lastName = level.name;
        }
      }
      statistics[lastName] += 1;
    }
    return statistics;
  }

  Future<HashMap<String, int>> getLevelsStatisticsForDb() async {
    var matrixDescription = await matrixDbRepository.loadSingle(this._matrixId);

    var items = matrixDescription.matrixDetail.items;

    var statistics = HashMap<String, int>();
    statistics[Consts.BASE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SIMPLE_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.SERIOUS_KNOWLEDGE_LEVEL] = 0;
    statistics[Consts.COMPLEX_KNOWLEDGE_LEVEL] = 0;

    for (KnowledgeItemDb item in items) {
      var levels = item.levels;
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

    for (KnowledgeItemEntity item in items) {
      itemsCount++;
      var levels = item.levels;
      for (KnowledgeLevelEntity level in levels) {
        if (level.isChecked && level.name == levelToCount) {
          completedLevels++;
        }
      }
    }
    progress = (completedLevels / itemsCount * 100).round();
    return progress;
  }

  Future<int> getMatrixProgressFromDb() async {
    var matrixDescription = await matrixDbRepository.loadSingle(this._matrixId);
    var items = matrixDescription.matrixDetail.items;

    //Progress is taken only for serious level
    var progress = 0;
    var levelToCount = Consts.COMPLEX_KNOWLEDGE_LEVEL;
    int itemsCount = 0;
    var completedLevels = 0;

    if (items.length == 0) {
      return progress;
    }

    for (KnowledgeItemEntity item in items) {
      itemsCount++;
      var levels = item.levels;
      for (KnowledgeLevelEntity level in levels) {
        if (level.isChecked && level.name == levelToCount) {
          completedLevels++;
        }
      }
    }

    progress = (completedLevels / itemsCount * 100).round();
    return progress;
  }
}