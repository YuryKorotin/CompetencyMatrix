import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_fire_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/repositories/remote_repository.dart';
import 'package:competency_matrix/screens/matrix_detail_creation_screen.dart';
import 'package:competency_matrix/screens/matrix_detail_edit_screen.dart';
import 'package:competency_matrix/screens/matrix_editable_detail_screen.dart';
import 'package:competency_matrix/utils/colors_provider.dart';
import 'package:competency_matrix/utils/dialog_helper.dart';
import 'package:competency_matrix/vendor/barprogressindicator.dart';
import 'package:competency_matrix/view/builders/matrix_item_builder.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';
import 'package:competency_matrix/screens/matrix_detail_screen.dart';
import 'package:competency_matrix/view/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(CompetencyMatrixApp());
}

class CompetencyMatrixApp extends StatelessWidget {
  static const String INFO_ICON_KEY = "info_icon";
  static const String COMPETENCY_MATRIX_KEY = "competency_matrix";
  static const String START_SCREEN_TITLE_KEY = "start_title_key";
  static const String LOADING_INDICATOR_KEY = "loading_indicator_key";
  static const String CREATE_NEW_KEY = "create_new_key";
  static const String HEADER_ITEM_KEY = "header_item_key";

  CompetencyMatrixApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      key: Key(START_SCREEN_TITLE_KEY),
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
  List<MatrixEntity> _originItems;
  List<MatrixEntity> _userItems = new List();
  BaseMatrixRepository matrixRepository =
      MatrixFireRepository(RemoteRepository());
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
        .then((onValue) => matrixDbRepository.load())
        .then((matrices) => setState(() {
              this
                  .items
                  .addAll(viewModelBuilder.buildFromLoadedDbItems(matrices));
              this._userItems = matrices;
            }));
  }

  @override
  void initState() {
    loadItems();
  }

  Widget buildContent() {
    var widget;
    if (items == null) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Loading matrices',
              key: Key(CompetencyMatrixApp.LOADING_INDICATOR_KEY),
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
              key: Key(CompetencyMatrixApp.HEADER_ITEM_KEY),
              style: Theme.of(context).textTheme.headline,
            ),
          );
        } else if (item is MatrixItem) {
          return buildSwipableItem(index, item);
        }
      },
    );

    return widget;
  }

  Widget buildSwipableItem(int index, MatrixItem item) {
    DialogHelper helper = new DialogHelper();
    int progress = item.progress;

    var itemContentWidget = ListTile(
        trailing: getEditIcon(item),
        leading: CircularPercentIndicator(
          radius: 48.0,
          lineWidth: 8.0,
          percent: progress / 100,
          center: new Icon(
            Icons.person_pin,
            size: 33.0,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MatrixEditableDetailScreen(items[index], () => refresh()),
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MatrixDetailScreen(items[index], () => refresh()),
            ),
          );
        });

    if (item.isEmbedded) {
      return itemContentWidget;
    }

    return new OnSlide(
        items: <ActionItems>[
          new ActionItems(
              icon: new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {},
                color: Colors.red,
              ),
              onPress: () {
                helper.showQuestionDialog(context, () {
                  matrixDbRepository.deleteMatrix(item.id);
                  refresh();
                }, "Attention", "Do you really want to delete item?");
              },
              backgroudColor: Colors.grey),
          new ActionItems(
              icon: new IconButton(
                icon: new Icon(Icons.mode_edit),
                onPressed: () {},
                color: Colors.blue,
              ),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MatrixDetailEditScreen(() => refresh(), item.id),
                  ),
                );
              },
              backgroudColor: Colors.grey),
          //new ActionItems(icon: new IconButton(  icon: new Icon(Icons.bookmark),
          //  onPressed: () {}, color: Colors.orange,
          //), onPress: (){},  backgroudColor: Colors.blueGrey),
        ],
        child: new Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          width: 200.0,
          height: 80.0,
          child: itemContentWidget,
        ));
  }

  Widget getEditIcon(MatrixItem matrix) {
    if (matrix.isEmbedded) {
      return null;
    } else {
      return GestureDetector(
        onTap: () {},
        child: Icon(Icons.ac_unit),
      );
    }
  }

  void refresh() {
    loadItems();
  }

  void _showPrivacyPolicy() async {
    const policyUrl = 'https://yurykorotin73.wixsite.com/competencymatrix';
    if (await canLaunch(policyUrl)) {
      await launch(policyUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info, key: Key(CompetencyMatrixApp.INFO_ICON_KEY)),
          onPressed: () {
            _showPrivacyPolicy();
          },
        )
      ]),
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
        key: Key(CompetencyMatrixApp.CREATE_NEW_KEY),
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

    for (MatrixEntity matrix in this._originItems) {
      if (maxId < matrix.id) {
        maxId = matrix.id;
      }
    }

    for (MatrixEntity matrix in this._userItems) {
      if (maxId < matrix.id) {
        maxId = matrix.id;
      }
    }
    return maxId + BigInt.from(1);
  }
}
