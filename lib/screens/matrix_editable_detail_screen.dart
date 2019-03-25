import 'package:competency_matrix/view/matrix_detail/diagram_widget.dart';
import 'package:competency_matrix/view/matrix_detail/knowledge_editable_list_widget.dart';
import 'package:competency_matrix/view/matrix_detail/knowledge_list_widget.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';
import 'package:flutter/material.dart';

class MatrixEditableDetailScreen extends StatefulWidget {

  final MatrixItem matrixItem;
  final void Function() updateMatrices;

  MatrixEditableDetailScreen(this.matrixItem, this.updateMatrices);

  @override
  State<StatefulWidget> createState() {
    return MatrixEditableState(this.matrixItem, this.updateMatrices);
  }

}

class MatrixEditableState extends State<MatrixEditableDetailScreen> {
  int _currentIndex = 0;
  List<Widget> _children;
  final MatrixItem matrixItem;
  final void Function() updateMatrices;

  MatrixEditableState(@required this.matrixItem, this.updateMatrices) {
    _children = [
      KnowledgeEditableListWidget(matrixItem.id, this.updateMatrices),
      DiagramWidget(matrixItem.id)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(matrixItem.name),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar:
      BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('List'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.graphic_eq),
            title: new Text('Diagram'),
          )
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}