import 'package:competency_matrix/view/models/list_item.dart';

class KnowledgeItem implements ListItem {
  String name;
  String description;
  bool isChecked;

  KnowledgeItem.origin(
      String name,
      String description,
      bool isChecked) {

    this.name = name;
    this.isChecked = isChecked;
    this.description = description;
  }
}