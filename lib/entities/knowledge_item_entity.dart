
import 'package:competency_matrix/entities/knowledge_level_enity.dart';

class KnowledgeItemEntity {
  BigInt id;
  String name;
  List<KnowledgeLevelEntity> levels;

  KnowledgeItemEntity(
      this.id,
      this.name,
      this.levels);
}