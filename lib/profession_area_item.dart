// A ListItem that contains data to display a profession area
import 'package:competency_matrix/list_item.dart';

class ProfessionAreaItem implements ListItem {
  final String name;
  final int progress;

  ProfessionAreaItem(this.name, this.progress);
}