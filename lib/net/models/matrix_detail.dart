import 'package:competency_matrix/net/models/knowledge_item.dart';

class MatrixDetail {
  final BigInt id;
  final String name;
  final List<KnowledgeItem> items;

  MatrixDetail({
    this.id,
    this.name,
    this.items
  });

  factory MatrixDetail.fromJson(Map<String, dynamic> json){

    var items = json['knowledge_items']as List;

    List<KnowledgeItem> itemList =
    items.map((i) => KnowledgeItem.fromJson(i)).toList();
    return new MatrixDetail(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        items: itemList,
    );
  }
}