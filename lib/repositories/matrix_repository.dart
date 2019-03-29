import 'dart:collection';
import 'dart:convert';

import 'package:competency_matrix/net/models/knowledge_level.dart';
import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/net/models/matrix_detail.dart';
import 'package:competency_matrix/net/models/matrix_list.dart';
import 'package:competency_matrix/repositories/matrix_detail_result.dart';
import 'package:competency_matrix/statistics/matrix_statistics.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

class MatrixRepository {


  Future<String> readFromFile(String path) async {
    return rootBundle.loadString(path);
  }

  Future<List<Matrix>> load() async {
    List<Matrix> matrices = await readFromFile('assets/json/matrices.json')
        .then((result) => json.decode(result))
        .then((jsonValue) => MatrixList.fromJson(jsonValue).matrices);


    var newMatrices = new List<Matrix>();
    for (var matrix in matrices) {
      var newMatrix = await matrixWithProgress(matrix);
      newMatrices.add(newMatrix);
    }

    return newMatrices;
  }

  Future<Matrix> matrixWithProgress(Matrix matrix) async {
    MatrixStatistics statistics = MatrixStatistics(matrix.id);
    var matrixProgress = await statistics.getMatrixProgress();

    return new Matrix(
        id: matrix.id,
        name: matrix.name,
        description: matrix.description,
        category: matrix.category,
        progress: matrixProgress);
  }

  Future<MatrixDetailResult> loadSingle(BigInt id) async {
    String matrixPath = sprintf('assets/json/matrices/%d.json', [id.toInt()]);
    print(matrixPath);
    var parsedItem = await
    readFromFile(matrixPath)
        .then((result) => json.decode(result))
        .then((jsonValue) => MatrixDetail.fromJson(jsonValue));

    MatrixPreferences preferences = MatrixPreferences(id);

    var levels = await preferences.getChosenLevels(id);
    var dependentLevelsToCheck = new HashMap<BigInt, List<BigInt>>();
    var dependentLevelsToUncheck = new HashMap<BigInt, List<BigInt>>();

    for (final item in parsedItem.items) {
      var currentLevels = new List<BigInt>();
      for (KnowledgeLevel level in item.levels) {
        if (levels.contains(level.id.toString())) {
          level.isChecked = true;
        } else {
          level.isChecked = false;
        }
        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToCheck[level.id] = levelsCopy;
      }

      currentLevels = new List<BigInt>();

      for (var i = item.levels.length - 1; i >= 0; i--) {
        KnowledgeLevel level = item.levels[i];

        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToUncheck[level.id] = levelsCopy;
      }
      
    }

    return new MatrixDetailResult.origin(
        parsedItem,
        dependentLevelsToCheck,
        dependentLevelsToUncheck);
  }
}