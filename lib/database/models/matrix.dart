class Matrix {
  final BigInt id;
  final String name;
  final String description;
  final String category;
  final bool isEmbedded;
  final int progress;

  Matrix(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.isEmbedded,
      this.progress});
}
