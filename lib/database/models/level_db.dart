import 'package:competency_matrix/entities/knowledge_level_enity.dart';

class LevelDb extends KnowledgeLevelEntity {
  LevelDb(BigInt id, String name, String description)
      : super(id, name, description, false);
}
