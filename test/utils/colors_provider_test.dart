
import 'package:competency_matrix/utils/colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:test_api/test_api.dart';

void main() {
  group("ColorsProvider", () {
    test(".getColorByProgress() provide color by progress", () async {
      ColorsProvider colorsProvider = new ColorsProvider();

      var mediumProgress = 49;
      var lowProgress = 20;
      var highProgress = 90;

      expect(colorsProvider.getColorByProgress(highProgress), equals(Colors.green));

      expect(colorsProvider.getColorByProgress(mediumProgress), equals(Colors.yellow));

      expect(colorsProvider.getColorByProgress(lowProgress), equals(Colors.red));
    });
  });
}