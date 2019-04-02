import 'package:competency_matrix/entities/knowledge_level_enity.dart';

class KnowledgeLevel extends KnowledgeLevelEntity{
  KnowledgeLevel(
    id,
    name,
    description,
    isChecked) : super(id, name, description, isChecked);

  factory KnowledgeLevel.fromJson(Map<String, dynamic> json){
    return new KnowledgeLevel(
        new BigInt.from(json["id"]),
        json['name'],
        json['description'],
        json['isChecked'],
    );
  }
}