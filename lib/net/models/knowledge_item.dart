import 'package:competency_matrix/entities/knowledge_item_entity.dart';
import 'package:competency_matrix/net/models/knowledge_level.dart';

class KnowledgeItem extends KnowledgeItemEntity {
  KnowledgeItem(
      BigInt id,
      String name,
      List<KnowledgeLevel> levels) : super (id, name, levels);

  factory KnowledgeItem.fromJson(Map<String, dynamic> json){

    var levels = json['levels']as List;

    List<KnowledgeLevel> levelList =
    levels.map((i) => KnowledgeLevel.fromJson(i)).toList();
    return new KnowledgeItem(
      new BigInt.from(json["id"]),
      json['name'],
      levelList,
    );
  }
}