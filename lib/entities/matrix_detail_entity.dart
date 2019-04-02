
import 'package:competency_matrix/entities/knowledge_item_entity.dart';

class MatrixDetailEntity {
  BigInt id;
  String name;
  List<KnowledgeItemEntity> items;

  MatrixDetailEntity(
      this.id,
      this.name,
      this.items);
}
