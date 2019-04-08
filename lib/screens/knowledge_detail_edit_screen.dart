import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/screens/knowledge_detail_creation_screen.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:flutter/material.dart';

class KnowledgeDetailEditScreen extends KnowledgeDetailCreationScreen {

  KnowledgeDetailEditScreen(Function() updateMatrix, BigInt matrixId): super(updateMatrix, matrixId);

  @override
  State<StatefulWidget> createState() {
    return KnowledgeEditState(this.updateMatrix, this.matrixId);
  }

}
class KnowledgeEditState extends KnowledgeCreationState {

  KnowledgeEditState(Function() updateMatrix, BigInt matrixId): super(updateMatrix, matrixId) {
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Creation of knowledge item"),
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
    resultList.add(new TextFormField(
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(labelText: 'Name'),
      validator: (val) =>
      val.length == 0  || val.length > 30 ? "Enter right name" : null,
      onSaved: (val) => this.knowledgeItemDb.name = val,
    ));
    for (LevelDb levelDb in knowledgeItemDb.levels) {
      var name = Consts.KNOWLEDGE_TO_HUMAN_MAP[levelDb.name].toUpperCase();
      resultList.add(new TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(labelText: "$name description"),
        validator: (val) =>
          val.length == 0 || val.length > 60 ? 'Enter right $name description' : null,
        onSaved: (val) => levelDb.description = val,
      ));
    }

    resultList.add(new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(onPressed: _submit,
      child: new Text('Create'),),));

    return resultList;
  }

  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var repository = MatrixRepositoryDb();
    repository.saveKnowledgeItem(knowledgeItemDb, matrixId);
    _showSnackBar("Data saved successfully");
  }

  void _showSnackBar(String text) {
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