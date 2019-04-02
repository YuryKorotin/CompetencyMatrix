import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/entities/knowledge_item_entity.dart';
import 'package:competency_matrix/entities/knowledge_level_enity.dart';

class KnowledgeItemDb extends KnowledgeItemEntity {
  KnowledgeItemDb(
      BigInt id, String name, List<LevelDb> levelDbItems)
      : super(id, name, levelDbItems);
}
