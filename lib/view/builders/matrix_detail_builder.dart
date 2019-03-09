import 'package:competency_matrix/net/models/matrix_detail.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';

class MatrixDetailBuilder {

  List<ListItem> buildFromLoadedItem(MatrixDetail parsedItem) {
    List<ListItem> viewItems = new List();

    for (final item in parsedItem.items) {

      HeadingItem header = HeadingItem(item.name);
      viewItems.add(header);
      for (final level in item.levels) {
        viewItems.add(
            new KnowledgeItem.origin(
                level.id,
                level.name,
                level.description,
                level.isChecked));
      }
    }

    return viewItems;
  }
}