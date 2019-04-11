import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/net/models/matrix.dart';

import 'fire_matrix.dart';

class FireMatrixList {
  final List<FireMatrix> matrices;

  FireMatrixList({
    this.matrices,
  });

  factory FireMatrixList.fromJson(List<dynamic> parsedJson) {

    List<FireMatrix> matrices = parsedJson.map((i) => FireMatrix.fromJson(i)).toList();

    return new FireMatrixList(
      matrices: matrices,
    );
  }

  List<Map<String, dynamic>> toJson() {
    return matrices.map((firematrix) =>
      firematrix.toJson()
    );
  }
}