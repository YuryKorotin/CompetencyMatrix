// A ListItem that contains data to display a profession area
import 'package:competency_matrix/view/models/list_item.dart';

class MatrixItem implements ListItem {
  String name;
  int progress;
  String description;
  BigInt id;


  MatrixItem(String name, int progress) {
    this.name = name;
    this.progress = progress;
    this.description = "Some description";
  }

  MatrixItem.origin(
      BigInt id,
      String name,
      int progress,
      String description) {
    this.id = id;
    this.name = name;
    this.progress = progress;
    this.description = description;
  }
}