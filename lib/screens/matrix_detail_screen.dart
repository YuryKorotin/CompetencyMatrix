import 'package:competency_matrix/matrix_item.dart';
import 'package:flutter/material.dart';

class MatrixDetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  final MatrixItem matrixItem;

  // In the constructor, require a Todo
  MatrixDetailScreen({Key key, @required this.matrixItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text(matrixItem.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(matrixItem.description),
      ),
    );
  }
}