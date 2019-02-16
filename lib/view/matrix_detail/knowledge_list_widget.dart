import 'package:competency_matrix/view/builders/matrix_detail_builder.dart';
import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:flutter/material.dart';

class KnowledgeListWidget extends StatefulWidget {
  KnowledgeListWidget(this.matrixId) : super();

  final BigInt matrixId;

  @override
  KnowledgeListState createState() => KnowledgeListState(this.matrixId);
}

class KnowledgeListState extends State<KnowledgeListWidget> {
  final BigInt matrixId;
  var _items;
  MatrixDetailBuilder viewModelBuilder = MatrixDetailBuilder();

  KnowledgeListState(this.matrixId) {
    _items = viewModelBuilder.buildStaticItems();
  }

  @override
  Widget build(BuildContext context) {
    var widget = ListView.builder(
      // Let the ListView know how many items it needs to build
      itemCount: _items.length,
      // Provide a builder function. This is where the magic happens! We'll
      // convert each item into a Widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = _items[index];

        if (item is HeadingItem) {
          return ListTile(
            title: Text(
              item.heading,
              style: Theme.of(context).textTheme.headline,
            ),
          );
        } else if (item is KnowledgeItem) {
          return CheckboxListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            value: item.isChecked,
            onChanged: (bool value) {
              setState(() { _items[index].isChecked = !item.isChecked; });
            },
          );
        }
      },
    );
    return widget;
  }
}
