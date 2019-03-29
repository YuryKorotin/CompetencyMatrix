
import 'package:competency_matrix/database/models/knowledge_db.dart';

class MatrixDetailDb {
  final BigInt id;
  final String name;
  List<KnowledgeItemDb> knowledgeDbItems;
  MatrixDetailDb({
    this.id,
    this.name,
    this.knowledgeDbItems});
}