import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';

class FireMatrix extends MatrixEntity {
  String timestamp = "";
  FireMatrix(BigInt id,
      String name,
      String description,
      String category,
      bool isEmbedded,
      int progress)
      : super(id, name, description, category, isEmbedded, progress);

  factory FireMatrix.fromDocument(DocumentSnapshot document){
    return new FireMatrix(
        BigInt.from(int.parse(document.documentID)),
        document['name'],
        document['description'],
        document['category'],
        document['embedded'],
        document['progress']);
  }
}