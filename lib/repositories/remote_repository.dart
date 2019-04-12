

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';
import 'package:competency_matrix/firestore/fire_knowledge_item.dart';
import 'package:competency_matrix/firestore/fire_matrix.dart';
import 'package:competency_matrix/firestore/fire_matrix_detail.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/statistics/matrix_statistics.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';

class RemoteRepository extends BaseMatrixRepository {
  @override
  Future<List<MatrixEntity>> load() async {
    List<MatrixEntity> matrices = new List();

    var snapshots = await Firestore.instance
        .collection('matrices')
        .getDocuments();

    snapshots.documents.forEach((snapshot) => matrices.add(FireMatrix.fromDocument(snapshot)));

    List<MatrixEntity> matricesWithProgress = List();

    for (MatrixEntity matrix in matrices) {
      var matrixFilled = await matrixWithProgress(matrix);

      matricesWithProgress.add(matrixFilled);
    }

    return matricesWithProgress;
  }

  @override
  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix) async {
    MatrixStatistics statistics = MatrixStatistics(matrix.id);
    var matrixProgress = await statistics.getMatrixProgress();

    return new FireMatrix(
        matrix.id,
        matrix.name,
        matrix.description,
        matrix.category,
        true,
        matrixProgress);
  }

  Future<List<DocumentSnapshot>> findLevelsForItem(DocumentReference documentReference) async {
    var levelSnapshots = List<DocumentSnapshot>();

    var querySnapshots = await Firestore.instance
        .collection('levels')
        .where("knowledge_item_id", isEqualTo: documentReference)
        .getDocuments();

    querySnapshots.documents.forEach((document) {
      levelSnapshots.add(document);
      print(document.data);
    });

    levelSnapshots.sort((a, b) => int.parse(a.documentID).compareTo(int.parse(b.documentID)));

    return levelSnapshots;
  }

  Future<MatrixDetailEntity> getMatrix(BigInt id) async {

    var itemSnapshots = List<DocumentSnapshot>();

    var documentReference = await Firestore.instance
        .collection('matrices')
        .document(id.toString());

    DocumentSnapshot document = await documentReference.get();

    var querySnapshots = await Firestore.instance
        .collection('knowledge_items')
        .where("matrix_id", isEqualTo: documentReference)
        .getDocuments();

    querySnapshots.documents.forEach((doc) {
      itemSnapshots.add(doc);
    });

    var builtItems = List<FireKnowledgeItem>();

    for (var i = 0; i < itemSnapshots.length; i++) {
      var doc = itemSnapshots[i];

      var levelSnapshots = await findLevelsForItem(doc.reference);

      var item = FireKnowledgeItem.fromDocument(doc, levelSnapshots);

      builtItems.add(item);
    }

    var builtItem = FireMatrixDetail.fromDocument(document);

    builtItem.items = builtItems;

    return builtItem;
  }

  @override
  Future<MatrixLoadResult> loadSingle(BigInt id) async {
    MatrixDetailEntity parsedItem = await getMatrix(id);

    return getLoadResult(parsedItem);
  }

  Future<MatrixLoadResult> getLoadResult(MatrixDetailEntity parsedItem) async {
    MatrixPreferences preferences = MatrixPreferences(parsedItem.id);

    var levels = await preferences.getChosenLevels(parsedItem.id);
    var dependentLevelsToCheck = new HashMap<BigInt, List<BigInt>>();
    var dependentLevelsToUncheck = new HashMap<BigInt, List<BigInt>>();

    for (final item in parsedItem.items) {
      var currentLevels = new List<BigInt>();
      for (var level in item.levels) {
        if (levels.contains(level.id.toString())) {
          level.isChecked = true;
        } else {
          level.isChecked = false;
        }
        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToCheck[level.id] = levelsCopy;
      }

      currentLevels = new List<BigInt>();

      for (var i = item.levels.length - 1; i >= 0; i--) {
        var level = item.levels[i];

        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToUncheck[level.id] = levelsCopy;
      }

    }

    return new MatrixLoadResult.origin(
        parsedItem,
        dependentLevelsToCheck,
        dependentLevelsToUncheck);
  }
}