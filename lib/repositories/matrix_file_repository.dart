import 'dart:convert';
import 'dart:io';

import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/firestore/fire_matrix.dart';
import 'package:competency_matrix/firestore/fire_matrix_detail.dart';
import 'package:competency_matrix/firestore/fire_matrix_list.dart';
import 'package:path_provider/path_provider.dart';

class MatrixFileRepository {
  final String detailsPath = "matrix_detailed";
  final String listPath = "matrix_list";
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getlocalFile(String name) async {
    final path = await _localPath;

    return File('$path/$name.txt');
  }


  Future<bool> wasItemCached(BigInt id) async {
    var file = await getlocalFile(detailsPath + id.toString());
    return file.exists();
  }

  Future<bool> wasListCached() async {
    var file = await getlocalFile(listPath);
    return file.exists();
  }

  Future<List<FireMatrix>> readList() async {
    List<FireMatrix> result = new List<FireMatrix>();

    try {
      final file = await getlocalFile(listPath);

      String contents = await file.readAsString();

      var jsonValue = await json.decode(contents);

      result = FireMatrixList.fromJson(jsonValue).matrices;
    } catch (e) {

      print("Error while reading file of cache");
    }

    return result;
  }

  Future<File> writeList(List<FireMatrix> matrices) async {
    final file = await getlocalFile(listPath);

    var matrixList = new FireMatrixList(matrices: matrices);

    return file.writeAsString(json.encode(matrixList.toJson()));
  }

  Future<FireMatrixDetail> readItem(BigInt id) async {
    MatrixDetailEntity result;

    try {
      final file = await getlocalFile(detailsPath + id.toString());

      String contents = await file.readAsString();
      print(contents);

      var jsonValue = await json.decode(contents);

      result = FireMatrixDetail.fromJson(jsonValue);
    } catch (e) {

      print("Error while reading file of cache");
    }

    return result;
  }

  Future<File> writeItem(FireMatrixDetail matrix) async {
    final file = await getlocalFile(detailsPath + matrix.id.toString());

    return file.writeAsString(json.encode((matrix).toJson()));
  }
}