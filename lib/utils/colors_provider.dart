
import 'package:flutter/material.dart';

class ColorsProvider{
  static const int SMALL_PROGRESS = 25;
  static const int MEDIUM_PROGRESS = 50;
  static const int BEST_PROGRESS = 100;

  MaterialColor getColorByProgress(int progress) {
    //TODO: Add gradients for progress
    if (progress >= 0 && progress <= SMALL_PROGRESS) {
      return Colors.red;
    } else if(progress > SMALL_PROGRESS && progress <= MEDIUM_PROGRESS) {
      return Colors.yellow;
    }  else if(progress > MEDIUM_PROGRESS && progress <= BEST_PROGRESS) {
      return Colors.green;
    }
    return Colors.red;
  }
}