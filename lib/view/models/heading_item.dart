// A ListItem that contains data to display a heading
import 'package:competency_matrix/view/models/list_item.dart';

class HeadingItem implements ListItem {
  final String heading;
  BigInt id;

  HeadingItem(this.heading);
}