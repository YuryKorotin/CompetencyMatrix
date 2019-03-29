
import 'package:competency_matrix/database/models/level_db.dart';

class KnowledgeItemDb {
  BigInt id;
  String name;
  List<LevelDb> levelDbItems;

  KnowledgeItemDb({
    this.id,
    this.name,
    this.levelDbItems});
}