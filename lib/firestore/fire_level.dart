import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competency_matrix/entities/knowledge_level_enity.dart';

class FireLevel extends KnowledgeLevelEntity{
  BigInt knowledgeItemId;
  FireLevel(
      id,
      name,
      description,
      isChecked) : super(id, name, description, isChecked);

  factory FireLevel.fromDocument(DocumentSnapshot document){
    FireLevel result = new FireLevel(
      BigInt.from(int.parse(document.documentID)),
      document['name'],
      document['description'],
      document['isChecked'],
    );

    return result;
  }

  factory FireLevel.fromJson(Map<String, dynamic> json) {
    FireLevel resultLevel =
    new FireLevel(
        BigInt.from(json['id']),
        json['name'],
        json['description'],
        false);
    return resultLevel;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id.toInt(),
        'name': name,
        'description': description
      };
}