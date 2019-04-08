import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/repositories/matrix_repository_db.dart';
import 'package:competency_matrix/screens/knowledge_detail_creation_screen.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:flutter/material.dart';

class KnowledgeDetailEditScreen extends KnowledgeDetailCreationScreen {

  BigInt itemId;

  KnowledgeDetailEditScreen(
      Function() updateMatrix,
      BigInt matrixId,
      this.itemId): super(updateMatrix, matrixId);

  @override
  State<StatefulWidget> createState() {
    return KnowledgeEditState(this.updateMatrix, this.matrixId, this.itemId);
  }

}
class KnowledgeEditState extends KnowledgeCreationState {
  BigInt itemId;


  KnowledgeEditState(
      Function() updateMatrix,
      BigInt matrixId, this.itemId): super(updateMatrix, matrixId) {
    title = "Update of knowledge item";
    actionButtonName = 'Update';
  }

  @override
  void initState() {
    repository
        .getKnowledgeItemForEdit(itemId)
        .then((parsedItem) =>
        setState(() {
          knowledgeItemDb = parsedItem;
        }));
  }

  @override
  void submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var repository = MatrixRepositoryDb();
    repository.updateKnowledgeItem(knowledgeItemDb);
    showSnackBar("Data updated successfully");
  }
}