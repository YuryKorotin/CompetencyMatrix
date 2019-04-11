import 'dart:io';

import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:path_provider/path_provider.dart';

class MatrixFileRepository {
  final const String detailsPath = "matrix_detailed";
  final const String listPath = "matrix_list";
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getlocalFile(String name) async {
    final path = await _localPath;
    return File('$path/$name.txt');
  }

  Future<List<MatrixEntity>> readList() async {
    List<MatrixEntity> result = new List<MatrixEntity>();

    try {
      final file = await getlocalFile(listPath);

      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeList(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}