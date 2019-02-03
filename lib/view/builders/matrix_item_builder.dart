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
        "profi"));
    items.add(new MatrixItem.origin(
        new BigInt.from(2),
        "Web programming",
        15,
        "beginner"));

    items.add(new HeadingItem("English speaking"));

    items.add(new MatrixItem.origin(
        new BigInt.from(3),
        "Grammar",
        50,
        "medium"));
    items.add(new MatrixItem.origin(
        new BigInt.from(3),
        "Speaking",
        25,
        "starter"));

    return items;
  }

  List<ListItem> buildFromLoadedItems(List<Matrix> items) {
    List<ListItem> viewItems = new List();

    for (final x in items) {
      viewItems.add(new MatrixItem.origin(
          x.id,
          x.name,
          x.progress,
          x.description));
    }

    return viewItems;
  }

}