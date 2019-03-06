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
    return new MatrixDetail(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        items: json['items'],
    );
  }
}