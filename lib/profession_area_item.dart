// A ListItem that contains data to display a profession area
import 'package:competency_matrix/list_item.dart';

class ProfessionAreaItem implements ListItem {
  final String sender;
  final String body;

  ProfessionAreaItem(this.sender, this.body);
}