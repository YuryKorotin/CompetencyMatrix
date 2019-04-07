import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/screens/matrix_detail_creation_screen.dart';
import 'package:flutter/material.dart';

class MatrixDetailEditScreen extends MatrixDetailCreationScreen {

  MatrixDetailEditScreen(Function() updateMatrices, BigInt newId) : super(updateMatrices, newId);

  @override
  State<StatefulWidget> createState() {
    return MatrixEditState(this.updateMatrices, this.newId);
  }
}

class MatrixEditState extends MatrixCreationState {

  @override
  void initMatrix() {
    title = "Updating of matrix";
    action = "Update";
    repository
        .loadForEdit(newId)
        .then((parsedItem) => setState(() {
          matrix = parsedItem;
    }));
  }

  MatrixEditState(Function() updateMatrices, BigInt newId) : super(updateMatrices, newId);

  void submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var matrix = MatrixDb(
        newId,
        name,
        description,
        category,
        false,
        0);
    repository.update(matrix);
    showSnackBar("Data saved successfully");
  }
}