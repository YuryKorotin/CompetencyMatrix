import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  final Color color;

  ListWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}