import 'dart:collection';

import 'package:competency_matrix/net/models/matrix_detail.dart';

class MatrixDetailResult{
  final MatrixDetail matrixDetail;
  final HashMap<BigInt, List<BigInt>> dependentItemsForCheck;
  final HashMap<BigInt, List<BigInt>> dependentItemsForUncheck;

  MatrixDetailResult.origin(
      this.matrixDetail,
      this.dependentItemsForCheck,
      this.dependentItemsForUncheck);
}