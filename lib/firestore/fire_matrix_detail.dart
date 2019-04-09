import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/firestore/fire_knowledge_item.dart';

class FireMatrixDetail extends MatrixDetailEntity{

  String timestamp = "";

  FireMatrixDetail(
      id,
      name,
      items) : super(id, name, items);

  factory FireMatrixDetail.fromDocument(
      DocumentSnapshot document){
    var result = new FireMatrixDetail(
      BigInt.from(int.parse(document.documentID)),
      document['name'],
      List<FireKnowledgeItem>(),
    );

    return result;
  }
}