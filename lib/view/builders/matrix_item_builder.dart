import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/net/models/matrix.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:competency_matrix/view/models/matrix_item.dart';

class MatrixItemBuilder {
  List<ListItem> buildStaticItems() {
    List<ListItem> items = new List();

    items.add(new HeadingItem("Programming"));

    items.add(new MatrixItem.origin(
        new BigInt.from(1),
        "Mobile programming",
        50,
        "profi",
        true));
    items.add(new MatrixItem.origin(
        new BigInt.from(2),
        "Web programming",
        15,
        "beginner",
        true));

    items.add(new HeadingItem("English speaking"));

    items.add(new MatrixItem.origin(
        new BigInt.from(3),
        "Grammar",
        50,
        "medium",
        true));
    items.add(new MatrixItem.origin(
        new BigInt.from(3),
        "Speaking",
        25,
        "starter",
        true));

    return items;
  }

  List<ListItem> buildFromLoadedItems(List<MatrixEntity> items) {
    List<ListItem> viewItems = new List();

    String currentCategory = items.first.category;
    HeadingItem header = HeadingItem(currentCategory);
    viewItems.add(header);

    for (final x in items) {
      if (x.category != currentCategory) {
        currentCategory = x.category;
        header = HeadingItem(currentCategory);
        viewItems.add(header);
      }
      viewItems.add(new MatrixItem.origin(
          x.id,
          x.name,
          x.progress,
          x.description,
          true));
    }

    return viewItems;
  }

  List<ListItem> buildFromLoadedDbItems(List<MatrixDb> items) {
    List<ListItem> viewItems = new List();

    if (items.isEmpty) {
      return viewItems;
    }

    String currentCategory = items.first.category;
    HeadingItem header = HeadingItem(currentCategory);
    viewItems.add(header);

    for (final x in items) {
      if (x.category != currentCategory) {
        currentCategory = x.category;
        header = HeadingItem(currentCategory);
        viewItems.add(header);
      }
      viewItems.add(new MatrixItem.origin(
          x.id,
          x.name,
          x.progress,
          x.description,
          false));
    }

    return viewItems;
  }

}