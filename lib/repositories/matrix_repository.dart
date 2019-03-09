import 'dart:convert';

import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/net/models/matrix_detail.dart';
import 'package:competency_matrix/net/models/matrix_list.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

class MatrixRepository {


  Future<String> readFromFile(String path) async {
    return rootBundle.loadString(path);
  }

  Future<List<Matrix>> load() async {
    return await
    readFromFile('assets/json/matrices.json')
        .then((result) => json.decode(result))
        .then((jsonValue) => MatrixList.fromJson(jsonValue).matrices);
  }

  Future<MatrixDetail> loadSingle(BigInt id) async {
    String matrixPath = sprintf('assets/json/matrices/%d.json', [id]);
    var parsedItem = await
    readFromFile(matrixPath)
        .then((result) => json.decode(result))
        .then((jsonValue) => MatrixDetail.fromJson(jsonValue));

    MatrixPreferences preferences = MatrixPreferences();

    var levels = await preferences.getChosenLevels(id);

    for (final item in parsedItem.items) {

      for (final level in item.levels) {
        if (levels.contains(level)) {
          level.isChecked = true;
        }
      }
    }

    return parsedItem;
  }
}