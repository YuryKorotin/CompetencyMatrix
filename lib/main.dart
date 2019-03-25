import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/screens/matrix_detail_creation_screen.dart';
import 'package:competency_matrix/screens/matrix_editable_detail_screen.dart';
import 'package:competency_matrix/utils/colors_provider.dart';
import 'package:competency_matrix/vendor/barprogressindicator.dart';
import 'package:competency_matrix/view/builders/matrix_item_builder.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';
import 'package:competency_matrix/screens/matrix_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> items;
  List<Matrix> _originItems;
  MatrixRepository matrixRepository = MatrixRepository();
  MatrixRepositoryDb matrixDbRepository = MatrixRepositoryDb();
  MatrixItemBuilder viewModelBuilder = MatrixItemBuilder();
  ColorsProvider _colorsProvider = ColorsProvider();

  _MyHomePageState();

  void loadItems() {
    matrixRepository
        .load()
        .then((parsedItems) => setState(() {
          this.items = viewModelBuilder.buildFromLoadedItems(parsedItems);
          this._originItems = parsedItems;
        }))
        .then((onValue) => matrixDbRepository.getMatrices())
        .then((matrices) => this.items.addAll(viewModelBuilder.buildFromLoadedDbItems(matrices)));
  }

  @override
  void initState() {
    loadItems();
  }

  Widget buildContent() {
    var widget = null;
    if (items == null) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Loading matrices',
              style: Theme.of(context).textTheme.title,
            ),
            BarProgressIndicator(
              numberOfBars: 4,
              color: Colors.grey,
              fontSize: 10.0,
              barSpacing: 2.0,
              beginTweenValue: 5.0,
              endTweenValue: 10.0,
              milliseconds: 200,
            ),
          ],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.
      return widget;
    }
    widget = ListView.builder(
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
            trailing: getEditIcon(item),
            //trailing: Icon(Icons.trip_origin),
            leading: CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: progress / 100,
              center: new Icon(
                Icons.person_pin,
                size: 30.0,
                color: _colorsProvider.getColorByProgress(progress),
              ),
              backgroundColor: Colors.grey,
              progressColor: _colorsProvider.getColorByProgress(progress),
            ),
            //leading: const Icon(Icons.flight_land),
            title: Text(item.name),
            subtitle: Text("Progress is $progress%"),
            onTap: () {
              if (!item.isEmbedded) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MatrixDetailScreen(items[index], () => refresh()),
                ),
              );
            },
          );
        }
      },
    );

    return widget;
  }

  Widget getEditIcon(MatrixItem matrix) {
    if (matrix.isEmbedded) {
      return null;
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MatrixEditableDetailScreen(matrix, () => refresh()),
            ),
          );
        },
        child: Icon(Icons.edit),
      );
    }
  }

  void refresh() {
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildContent(),

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MatrixDetailCreationScreen(() => refresh(), findNewId()),
            ),
          );
        },
        tooltip: 'Create new matrix',
        child: Icon(Icons.add),
      ),
    );
  }

  BigInt findNewId() {
    var maxId = this._originItems.first.id;

    for(Matrix matrix in this._originItems) {
      if (maxId < matrix.id) {
        maxId = matrix.id;
      }
    }
    return maxId;
  }
}
