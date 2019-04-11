import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competency_matrix/entities/knowledge_item_entity.dart';
import 'package:competency_matrix/firestore/fire_level.dart';

class FireKnowledgeItem extends KnowledgeItemEntity {
  BigInt matrixId;

  FireKnowledgeItem(
      BigInt id,
      String name,
      List<FireLevel> levels) : super (id, name, levels);

  factory FireKnowledgeItem.fromDocument(DocumentSnapshot document, List<DocumentSnapshot> levelSnapshots){
    List<FireLevel> levels = new List();
    levelSnapshots.forEach((doc) =>  levels.add(FireLevel.fromDocument(doc)));

    var result = new FireKnowledgeItem(
      BigInt.from(int.parse(document.documentID)),
      document['name'],
      levels,
    );


    return result;
  }

  factory FireKnowledgeItem.fromJson(Map<String, dynamic> json) {
    var levels = (json['levels'] as List).map((i) => FireLevel.fromJson(i)).toList();

    print(levels);

    print(json);

    FireKnowledgeItem resultItem = new FireKnowledgeItem(
        BigInt.from(json['id']),
        json['name'],
        levels);
    return resultItem;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id.toInt(),
        'name': name,
        'levels': levels.map((item) => (item as FireLevel).toJson()).toList()
      };
}