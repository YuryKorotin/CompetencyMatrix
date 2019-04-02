

import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';

class RemoteRepository extends BaseMatrixRepository {
  @override
  Future<List<MatrixEntity>> load() {

    return null;
  }

  @override
  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix) {

    return null;
  }

  @override
  Future<MatrixLoadResult> loadSingle(BigInt id) {
    return null;
  }

}