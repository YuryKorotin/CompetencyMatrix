

import 'dart:collection';

import 'package:competency_matrix/entities/matrix_detail_entity.dart';

class MatrixLoadResult{
  final MatrixDetailEntity matrixDetail;
  final HashMap<BigInt, List<BigInt>> dependentItemsForCheck;
  final HashMap<BigInt, List<BigInt>> dependentItemsForUncheck;

  MatrixLoadResult.origin(
      this.matrixDetail,
      this.dependentItemsForCheck,
      this.dependentItemsForUncheck);
}