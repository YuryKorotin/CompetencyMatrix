import 'package:competency_matrix/heading_item.dart';
import 'package:competency_matrix/list_item.dart';
import 'package:competency_matrix/matrix_item.dart';
import 'package:competency_matrix/screens/matrix_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


//Create builder of static items for fast scaffolding
List<ListItem> buildStaticItems() {
  List<ListItem> items = new List();

  items.add(new HeadingItem("Programming"));

  items.add(new MatrixItem("Mobile programming", 50));
  items.add(new MatrixItem("Web programming", 15));

  items.add(new HeadingItem("English speaking"));

  items.add(new MatrixItem("Grammar", 50));
  items.add(new MatrixItem("Speaking", 25));

  return items;
}

void main() {
  runApp(CompetencyMatrixApp(
    items : buildStaticItems()
  ));
}

class CompetencyMatrixApp extends StatelessWidget {
  final List<ListItem> items;

  CompetencyMatrixApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Competency Matrix',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Profession Areas', items: items),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<ListItem> items;

  MyHomePage({Key key, this.title, @required this.items}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(items);
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> items;

  _MyHomePageState(List<ListItem> items) {
    this.items = items;
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
