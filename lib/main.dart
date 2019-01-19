import 'package:competency_matrix/heading_item.dart';
import 'package:competency_matrix/list_item.dart';
import 'package:competency_matrix/profession_area_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


//Create builder of static items for fast scaffolding
List<ListItem> buildStaticItems() {
  List<ListItem> items = new List(6);

  items.add(new HeadingItem("Programming"));

  items.add(new ProfessionAreaItem("Mobile programming", 50));
  items.add(new ProfessionAreaItem("Web programming", 15));
  
  items.add(new HeadingItem("English speaking"));

  items.add(new ProfessionAreaItem("Grammar", 50));
  items.add(new ProfessionAreaItem("Speaking", 25));

  return items;
}

void main() => runApp(CompetencyMatrixApp());

class CompetencyMatrixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competency Matrix',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Profession Areas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
