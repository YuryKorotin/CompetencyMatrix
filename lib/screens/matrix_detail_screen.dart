import 'package:competency_matrix/view/matrix_detail/diagram_widget.dart';
import 'package:competency_matrix/view/matrix_detail/knowledge_list_widget.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';
import 'package:flutter/material.dart';

class MatrixDetailScreen extends StatefulWidget {

  final MatrixItem matrixItem;

  MatrixDetailScreen(this.matrixItem);

  @override
  State<StatefulWidget> createState() {
    return MatrixState(this.matrixItem);
  }

}
class MatrixState extends State<MatrixDetailScreen> {
  int _currentIndex = 0;
  List<Widget> _children;
  final MatrixItem matrixItem;

  MatrixState(@required this.matrixItem) {
    _children = [
      KnowledgeListWidget(matrixItem.id),
      DiagramWidget(matrixItem.id)
    ];
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matrixItem.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(matrixItem.description),
        child:
      ),
    );
  }*/
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
      /*body: new Center(
        child: new AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData: _buildRandomKnowledgeData(),
          chartType: CircularChartType.Radial,
        ),
      ),*/
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}