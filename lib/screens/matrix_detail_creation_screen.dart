import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:flutter/material.dart';

class MatrixDetailCreationScreen extends StatefulWidget {

  MatrixDetailCreationScreen();

  @override
  State<StatefulWidget> createState() {
    return MatrixCreationState();
  }

}
class MatrixCreationState extends State<MatrixDetailCreationScreen> {

  MatrixDb matrix = new MatrixDb(id: BigInt.from(0), name: "",  description: "", category: "", isEmbedded: false, progress: 0);

  String name;
  String description;
  String category;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Creation of matrix"),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.view_list),
              tooltip: 'Next choice',
              onPressed: () {
                navigateToMatrixList();
              },
            ),
          ]
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (val) =>
                val.length == 0 ?"Enter name" : null,
                onSaved: (val) => this.name = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Category'),
                validator: (val) =>
                val.length ==0 ? 'Enter category' : null,
                onSaved: (val) => this.category = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Description'),
                validator: (val) =>
                val.length ==0 ? 'Enter description' : null,
                onSaved: (val) => this.description = val,
              ),
              /*new TextFormField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(labelText: 'Mobile No'),
                validator: (val) =>
                val.length ==0 ? 'Enter Mobile No' : null,
                onSaved: (val) => this.mobileno = val,
              ),*/
              /*new TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(labelText: 'Email Id'),
                validator: (val) =>
                val.length ==0 ? 'Enter Email Id' : null,
                onSaved: (val) => this.emailId = val,
              ),*/
              new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(onPressed: _submit,
                child: new Text('Create'),),)

            ],
          ),
        ),
      ),
    );
  }
  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var matrix = MatrixDb(
        id: BigInt.from(0),
        name: name,
        description: description,
        category: category,
        isEmbedded: false,
        progress: 0);
    var repository = MatrixRepositoryDb();
    repository.saveMatrix(matrix);
    _showSnackBar("Data saved successfully");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
    navigateToMatrixList();
  }

  void navigateToMatrixList(){
    Navigator.pop(context);
  }
}