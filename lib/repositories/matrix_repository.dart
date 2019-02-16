import 'dart:convert';

import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/net/models/matrix_list.dart';
import 'package:flutter/services.dart';

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
}