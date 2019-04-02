import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/net/models/matrix.dart';

class MatrixList {
  final List<MatrixEntity> matrices;

  MatrixList({
    this.matrices,
  });

  factory MatrixList.fromJson(List<dynamic> parsedJson) {

    List<MatrixEntity> matrices = parsedJson.map((i) => Matrix.fromJson(i)).toList();

    return new MatrixList(
      matrices: matrices,
    );
  }
}