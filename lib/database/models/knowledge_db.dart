
import 'package:competency_matrix/database/models/level_db.dart';

class KnowledgeItemDb {
  final BigInt id;
  final String name;
  List<LevelDb> levelDbItems;

  KnowledgeItemDb({
    this.id,
    this.name,
    this.levelDbItems});
}