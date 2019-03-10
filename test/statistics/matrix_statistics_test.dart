import 'dart:collection';

import 'package:competency_matrix/statistics/matrix_statistics.dart';
import 'package:competency_matrix/utils/consts.dart';
import "package:test/test.dart";

void main() {
  group("MatrixStatistics", () {
    test(".getLevels() calculates count of items with special levels", () async {
      var testMatrixId = BigInt.from(1);

      var statistics = MatrixStatistics(testMatrixId);

      var levelsStatistics = await statistics.getLevelsStatistics();

      expect(levelsStatistics.containsKey(Consts.BASE_KNOWLEDGE_LEVEL), equals(true));
    });
  });
}