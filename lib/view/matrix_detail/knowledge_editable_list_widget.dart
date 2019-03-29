import 'dart:collection';

import 'package:competency_matrix/interactors/matrix_detail_interactor.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/screens/knowledge_detail_creation_screen.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';
import 'package:competency_matrix/view/builders/matrix_detail_builder.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class KnowledgeEditableListWidget extends StatefulWidget {
  KnowledgeEditableListWidget(this.matrixId, this.updateMatrices) : super();

  final BigInt matrixId;
  final void Function() updateMatrices;

  @override
  KnowledgeEditableListState createState() => KnowledgeEditableListState(this.matrixId, this.updateMatrices);
}

class KnowledgeEditableListState extends State<KnowledgeEditableListWidget> {
  BigInt _matrixId;
  var _items;
  var _errorHasOccured = false;
  HashMap<BigInt, List<BigInt>> _levelSchemeToCheck;
  HashMap<BigInt, List<BigInt>> _levelSchemeToUncheck;

  MatrixRepositoryDb matrixRepository = MatrixRepositoryDb();
  MatrixPreferences matrixPreferences;
  MatrixDetailBuilder viewModelBuilder = MatrixDetailBuilder();
  final void Function() updateMatrices;


  KnowledgeEditableListState(BigInt matrixId, this.updateMatrices) {
    this._matrixId = matrixId;
    this.matrixPreferences = MatrixPreferences(_matrixId);
  }

  @override
  void initState() {
    loadItems();
  }

  void loadItems() {
    try {
      matrixRepository.loadSingle(this._matrixId).then((loadedItem) =>
          setState(() {
            this._items =
                viewModelBuilder.buildFromDbItem(loadedItem.matrixDetail);
            this._levelSchemeToCheck = loadedItem.dependentItemsForCheck;
            this._levelSchemeToUncheck = loadedItem.dependentItemsForUncheck;
          }));
    } catch (e) {
      _errorHasOccured = true;
    }
  }

  Widget buildContent() {
    var widget;
    if (this._items == null && !_errorHasOccured) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[JumpingDotsProgressIndicator(fontSize: 20.0)],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.
      return widget;
    }
    if (this._items == null && _errorHasOccured) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Error while loading")],
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
              setState(() {
                _items[index].isChecked = value;
                if(_items[index].isChecked) {
                  checkPreviousLevelsIfNeed(index);
                } else {
                  uncheckPreviousLevelsIfNeed(index);
                }
                updateMatrices();
              });
            },
          );
        }
      },
    );
    return widget;
  }

  void refresh() {
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: buildContent()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  KnowledgeDetailCreationScreen(() => refresh(), _matrixId),
            ),
          );
        },
        tooltip: 'Create new matrix',
        child: Icon(Icons.add),
      )
    );
  }

  void checkPreviousLevelsIfNeed(int index) {
    List<BigInt> dependentItems = _levelSchemeToCheck[_items[index].id];
    for(BigInt id in dependentItems) {
      matrixPreferences.addLevel(id);
      for(ListItem element in _items) {
          if(element is KnowledgeItem) {
            if (id == element.id) {
              element.isChecked = true;
            }
          }
      }
    }
  }

  void uncheckPreviousLevelsIfNeed(int index) {
    List<BigInt> dependentItems = _levelSchemeToUncheck[_items[index].id];
    for(BigInt id in dependentItems) {
      matrixPreferences.removeLevel(id);
      for(ListItem element in _items) {
        if(element is KnowledgeItem) {
          if (id == element.id) {
            element.isChecked = false;
          }
        }
      }
    }
  }
}
