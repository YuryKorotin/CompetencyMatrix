import 'package:competency_matrix/database/models/matrix_detaildb.dart';
import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/net/models/matrix_detail.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';

class MatrixDetailBuilder {

  List<ListItem> buildFromLoadedItem(MatrixDetailEntity parsedItem) {
    List<ListItem> viewItems = new List();

    for (final item in parsedItem.items) {

      HeadingItem header = HeadingItem(item.name);
      header.id = item.id;
      viewItems.add(header);
      for (final level in item.levels) {
        var itemName = level.name;
        if (Consts.KNOWLEDGE_TO_HUMAN_MAP[level.name] != null) {
          itemName = Consts.KNOWLEDGE_TO_HUMAN_MAP[level.name];
        }
        viewItems.add(
            new KnowledgeItem.origin(
                level.id,
                itemName,
                level.description,
                level.isChecked));
      }
    }

    return viewItems;
  }
}