import 'package:competency_matrix/net/models/knowledge_level.dart';

class KnowledgeItem {
  final BigInt id;
  final String name;
  final List<KnowledgeLevel> levels;

  KnowledgeItem({
    this.id,
    this.name,
    this.levels
  });

  factory KnowledgeItem.fromJson(Map<String, dynamic> json){

    var levels = json['levels']as List;

    List<KnowledgeLevel> levelList =
    levels.map((i) => KnowledgeLevel.fromJson(i)).toList();
    return new KnowledgeItem(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        levels: levelList,
    );
  }
}