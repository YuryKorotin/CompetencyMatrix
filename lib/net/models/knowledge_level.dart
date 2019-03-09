class KnowledgeLevel {
  final BigInt id;
  final String name;
  final String description;
  bool isChecked;

  KnowledgeLevel({
    this.id,
    this.name,
    this.description,
    this.isChecked,
  });

  factory KnowledgeLevel.fromJson(Map<String, dynamic> json){
    return new KnowledgeLevel(
        id : new BigInt.from(json["id"]),
        name: json['name'],
        description: json['description'],
        isChecked: json['isChecked'],
    );
  }
}