import 'dart:collection';

import 'package:competency_matrix/statistics/matrix_statistics.dart';
import "package:test/test.dart";

void main() {
  group("MatrixStatistics", () {
    test(".getLevels() calculates count of items with special levels", () {
      var testMatrixId = BigInt.from(1);

      var statistics = MatrixStatistics(testMatrixId);

      HashMap<String, int> levelsStatistics = statistics.getLevelsStatistics();

      expect(levelsStatistics.containsValue("middle"), equals(true));
    });

    test(".trim() removes surrounding whitespace", () {
      var string = "  foo ";
      expect(string.trim(), equals("foo"));
    });
  });
}