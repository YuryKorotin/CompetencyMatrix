// A ListItem that contains data to display a profession area
import 'package:competency_matrix/view/models/list_item.dart';

class MatrixItem implements ListItem {
  BigInt id;
  String name;
  int progress;
  String description;


  MatrixItem(String name, int progress) {
    this.id = new BigInt.from(0);
    this.name = name;
    this.progress = progress;
    this.description = "Some description";
  }

  MatrixItem.origin(
      String name,
      int progress,
      String description,
      BigInt id) {
    this.id = id;
    this.name = name;
    this.progress = progress;
    this.description = "";
  }
}