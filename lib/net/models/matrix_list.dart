import 'package:competency_matrix/net/models/matrix.dart';

class MatrixList {
  final List<Matrix> matrices;

  MatrixList({
    this.matrices,
  });

  factory MatrixList.fromJson(List<dynamic> parsedJson) {

    List<Matrix> matrices = parsedJson.map((i) => Matrix.fromJson(i)).toList();

    return new MatrixList(
      matrices: matrices,
    );
  }
}