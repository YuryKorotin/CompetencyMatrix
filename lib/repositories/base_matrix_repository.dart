

import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';

abstract class BaseMatrixRepository {
  Future<List<MatrixEntity>> load();

  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix);

  Future<MatrixLoadResult> loadSingle(BigInt id);
}