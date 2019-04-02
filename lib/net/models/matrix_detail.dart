import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/net/models/knowledge_item.dart';

class MatrixDetail extends MatrixDetailEntity{
  MatrixDetail(
    id,
    name,
    items) : super(id, name, items);

  factory MatrixDetail.fromJson(Map<String, dynamic> json){

    var items = json['knowledge_items']as List;

    List<KnowledgeItem> itemList =
    items.map((i) => KnowledgeItem.fromJson(i)).toList();
    return new MatrixDetail(
        new BigInt.from(json["id"]),
        json['name'],
        itemList,
    );
  }
}