
class MatrixEntity {
  BigInt id;
  String name;
  String description;
  String category;
  bool isEmbedded;
  int progress;

  MatrixEntity(
      this.id,
      this.name,
      this.description,
      this.category,
      this.isEmbedded,
      this.progress);
}
