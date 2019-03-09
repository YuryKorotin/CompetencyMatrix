import 'package:competency_matrix/view/models/list_item.dart';

class KnowledgeItem implements ListItem {
  String name;
  String description;
  bool isChecked;
  BigInt id;

  KnowledgeItem.origin(
      BigInt id,
      String name,
      String description,
      bool isChecked) {

    this.id = id;
    this.name = name;
    this.isChecked = isChecked;
    this.description = description;
  }
}