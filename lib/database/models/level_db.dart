

class LevelDb {
  BigInt id;
  final String name;
  String description;
  bool isChecked = false;

  LevelDb(
      {this.id,
        this.name,
        this.description});
}