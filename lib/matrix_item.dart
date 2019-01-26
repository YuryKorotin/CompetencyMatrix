// A ListItem that contains data to display a profession area
import 'package:competency_matrix/list_item.dart';

class MatrixItem implements ListItem {
  String name;
  int progress;
  String description;


  MatrixItem(String name, int progress) {
    name = name;
    progress = progress;
    description = "Some description";
  }

  MatrixItem.origin(String name, int progress, String description) {
    this.name = name;
    this.progress = progress;
    this.description = "";
  }
}