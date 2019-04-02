
import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/entities/knowledge_item_entity.dart';
import 'package:competency_matrix/entities/matrix_detail_entity.dart';

class MatrixDetailDb extends MatrixDetailEntity {
  MatrixDetailDb(
    BigInt id,
    String name,
    List<KnowledgeItemDb> knowledgeDbItems) : super(id, name, knowledgeDbItems);
}