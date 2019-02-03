import 'dart:convert';

import 'package:competency_matrix/repositories/matrixRepository.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';
import 'package:competency_matrix/screens/matrix_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


void main() {

  runApp(CompetencyMatrixApp());
}

class CompetencyMatrixApp extends StatelessWidget {

  CompetencyMatrixApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competency Matrix',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Matrices'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<ListItem> items;


  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> items;
  MatrixRepository matrixRepository;

  _MyHomePageState() {
    matrixRepository = MatrixRepository();

    matrixRepository.load().then((val) => setState(() {
      this.items = buildListItems(items);
    }));
  }

  //int _counter = 0;

  void _incrementCounter() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens! We'll
        // convert each item into a Widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is HeadingItem) {
            return ListTile(
              title: Text(
                item.heading,
                style: Theme.of(context).textTheme.headline,
              ),
            );
          } else if (item is MatrixItem) {
            int progress = item.progress;
            return ListTile(
              title: Text(item.name),
              subtitle: Text("Progress is $progress%"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatrixDetailScreen(matrixItem: items[index]),
                  ),
                );
              },
            );
          }
        },
      ),

      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
