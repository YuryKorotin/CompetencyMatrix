import 'package:competency_matrix/entities/matrix_entity.dart';

class Matrix extends MatrixEntity {
  Matrix(BigInt id,
    String name,
    String description,
    String category,
    bool isEmbedded,
    int progress
  ) : super(id, name, description, category, isEmbedded, progress);

  factory Matrix.fromJson(Map<String, dynamic> json){
    return new Matrix(
        new BigInt.from(json["id"]),
        json['name'],
        json['description'],
        json['category'],
        json['embedded'],
        json["progress"]
    );
  }
}