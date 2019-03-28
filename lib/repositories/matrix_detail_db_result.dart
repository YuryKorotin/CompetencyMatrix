import 'dart:collection';

import 'package:competency_matrix/database/models/matrix_detaildb.dart';
import 'package:competency_matrix/net/models/matrix_detail.dart';

class MatrixDetailDbResult{
  final MatrixDetailDb matrixDetail;
  final HashMap<BigInt, List<BigInt>> dependentItemsForCheck;
  final HashMap<BigInt, List<BigInt>> dependentItemsForUncheck;

  MatrixDetailDbResult.origin(
      this.matrixDetail,
      this.dependentItemsForCheck,
      this.dependentItemsForUncheck);
}