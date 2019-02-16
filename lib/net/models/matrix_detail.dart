class MatrixDetail {
  final BigInt id;
  final String name;
  final String description;
  final String category;
  final int progress;

  MatrixDetail({
    this.id,
    this.name,
    this.description,
    this.category,
    this.progress
  });

  factory MatrixDetail.fromJson(Map<String, dynamic> json){
    return new MatrixDetail(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        description: json['description'],
        category: json['category'],
        progress: json["progress"]
    );
  }
}