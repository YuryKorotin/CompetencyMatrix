import 'package:dartson/dartson.dart';



class Matrix {

  final BigInt id;
  final String name;
  final String description;
  final int progress;

  Matrix({
    this.id,
    this.name,
    this.description,
    this.progress
  });

  factory Matrix.fromJson(Map<String, dynamic> json){
    return new Matrix(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        description: json['description'],
        progress: json["progress"]
    );
  }
}