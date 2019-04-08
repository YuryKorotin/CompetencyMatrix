import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:flutter/material.dart';

class KnowledgeDetailCreationScreen extends StatefulWidget {

  final void Function() updateMatrix;

  final BigInt matrixId;

  KnowledgeDetailCreationScreen(this.updateMatrix, this.matrixId);

  @override
  State<StatefulWidget> createState() {
    return KnowledgeCreationState(this.updateMatrix, this.matrixId);
  }

}
class KnowledgeCreationState extends State<KnowledgeDetailCreationScreen> {

  KnowledgeCreationState(this.updateMatrix, this.matrixId) {
    title = "Creation of knowledge item";
    actionButtonName = 'Create';
  }

  void initState() {
    List<LevelDb> levels = new List<LevelDb>();
    var names = Consts.KNOWLEDGE_TO_HUMAN_MAP.keys.toList();

    for(var i = 0; i < names.length; i++) {
      levels.add(
          new LevelDb(
              BigInt.from(i),
              names[i],
              ""
          ));
    }

    setState(() {
      knowledgeItemDb = new KnowledgeItemDb(
          BigInt.from(0),
          "",
          levels);
    });
  }

  KnowledgeItemDb knowledgeItemDb;

  String name;
  String description;
  String category;

  String title;
  String actionButtonName;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final void Function() updateMatrix;
  final BigInt matrixId;
  var repository = MatrixRepositoryDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.view_list),
              tooltip: 'Next choice',
              onPressed: () {
                navigateToMatrix();
              },
            ),
          ]
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: fieldsForLevels()
          ),
        ),
      ),
    );
  }

  List<Widget> fieldsForLevels() {
    List<Widget> resultList = List<Widget>();

    if (knowledgeItemDb == null) {
      return resultList;
    }

    resultList.add(new TextFormField(
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(labelText: 'Name'),
      validator: (val) =>
      val.length == 0  || val.length > 30 ? "Enter right name" : null,
      initialValue: knowledgeItemDb.name,
      onSaved: (val) => this.knowledgeItemDb.name = val,
    ));
    for (LevelDb levelDb in knowledgeItemDb.levels) {
      var name = Consts.KNOWLEDGE_TO_HUMAN_MAP[levelDb.name].toUpperCase();
      resultList.add(new TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(labelText: "$name description"),
        initialValue: levelDb.description,
        validator: (val) =>
          val.length == 0 || val.length > 60 ? 'Enter right $name description' : null,
        onSaved: (val) => levelDb.description = val,
      ));
    }

    resultList.add(
        new Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: new RaisedButton(
            onPressed: submit,
            child: new Text(actionButtonName))));

    return resultList;
  }

  void submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    repository.saveKnowledgeItem(knowledgeItemDb, matrixId);
    showSnackBar("Data saved successfully");
  }

  void showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
    navigateToMatrix();
  }

  void navigateToMatrix() {
    updateMatrix();

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();
    });
  }
}