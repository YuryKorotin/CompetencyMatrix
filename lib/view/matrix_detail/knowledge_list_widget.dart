import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';
import 'package:competency_matrix/view/builders/matrix_detail_builder.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class KnowledgeListWidget extends StatefulWidget {
  KnowledgeListWidget(this.matrixId, this.updateMatrices) : super();

  final BigInt matrixId;
  final void Function() updateMatrices;

  @override
  KnowledgeListState createState() => KnowledgeListState(this.matrixId, this.updateMatrices);
}

class KnowledgeListState extends State<KnowledgeListWidget> {
  BigInt _matrixId;
  var _items;
  MatrixRepository matrixRepository;
  MatrixPreferences matrixPreferences;
  MatrixDetailBuilder viewModelBuilder = MatrixDetailBuilder();
  final void Function() updateMatrices;

  KnowledgeListState(BigInt matrixId, this.updateMatrices) {
    this._matrixId = matrixId;
    this.matrixPreferences = MatrixPreferences(_matrixId);
  }

  @override
  void initState() {
    matrixRepository = MatrixRepository();

    matrixRepository.loadSingle(this._matrixId).then((parsedItem) => setState(() {
      this._items = viewModelBuilder.buildFromLoadedItem(parsedItem);
    }));
  }

  Widget buildContent() {
    var widget;
    if (this._items == null) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[JumpingDotsProgressIndicator(fontSize: 20.0)],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.
      return widget;
    }
    widget = ListView.builder(
      // Let the ListView know how many items it needs to build
      itemCount: _items.length,
      // Provide a builder function. This is where the magic happens! We'll
      // convert each item into a Widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = _items[index];

        if (item is HeadingItem) {
          return ListTile(
            title: Text(
              item.heading,
              style: Theme.of(context).textTheme.headline,
            ),
          );
        } else if (item is KnowledgeItem) {
          return CheckboxListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            value: item.isChecked,
            onChanged: (bool value) {
              updateMatrices();
              setState(() {
                _items[index].isChecked = value;
                if(_items[index].isChecked) {
                  matrixPreferences.addLevel(_items[index].id);
                } else {
                  matrixPreferences.removeLevel(_items[index].id);
                }
              });
            },
          );
        }
      },
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: buildContent()
      ),
    );
  }
}
