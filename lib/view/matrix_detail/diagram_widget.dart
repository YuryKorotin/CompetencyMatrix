import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_repository.dart';
import 'package:competency_matrix/repositories/remote_repository.dart';
import 'package:competency_matrix/statistics/knowledge_progress.dart';
import 'package:competency_matrix/statistics/matrix_statistics.dart';
import 'package:competency_matrix/utils/color_pallette.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:competency_matrix/view/builders/matrix_detail_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as Math;

import 'package:progress_indicators/progress_indicators.dart';

class DiagramWidget extends StatefulWidget {
  DiagramWidget(this._matrixId) : super();

  final BigInt _matrixId;

  @override
  KnowledgeDiagramState createState() => KnowledgeDiagramState(this._matrixId);
}

class KnowledgeDiagramState extends State<DiagramWidget> {
  BigInt _matrixId;
  List<KnowledgeProgress> _items;

  List<charts.Series> _seriesList;
  bool _animate;

  BaseMatrixRepository matrixRepository;
  MatrixStatistics _statistics;

  KnowledgeDiagramState(BigInt matrixId) {
    this._matrixId = matrixId;
    this._items = List<KnowledgeProgress>();
    this._animate = false;
    this._statistics = MatrixStatistics(_matrixId);
  }

  @override
  void initState() {
    matrixRepository = RemoteRepository();

    _statistics.getLevelsStatistics().then((statisticsMap) =>
        setState(() {
          statisticsMap.forEach((key, value) {
            if (value > 0) {
              _items.add(
                  KnowledgeProgress(Consts.KNOWLEDGE_TO_HUMAN_MAP[key], value));
            }
            print('$key$value');
          });

          this._seriesList = [
            new charts.Series<KnowledgeProgress, int>(
              id: 'Progress',
              domainFn: (KnowledgeProgress progress, _) =>
              progress.name.hashCode,
              measureFn: (KnowledgeProgress progress, _) => progress.count,
              data: _items,
              // Set a label accessor to control the text of the arc label.
              labelAccessorFn: (KnowledgeProgress row, _) => '${row.name}(${row.count})',
            )
          ];
        }));
  }

  Widget buildContent() {
    var widget;
    if (this._seriesList == null) {
      widget = new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[JumpingDotsProgressIndicator(fontSize: 20.0)],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.
      return widget;
    }

    widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Padding(
            padding: new EdgeInsets.all(22.0),
            child: Text(
              'Your skills statistics',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
        buildDiagram(),
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
    return widget;
  }

  Widget buildDiagram() {
    return new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 400.0,
        child: new charts.PieChart(_seriesList,
            animate: _animate,
            // Configure the width of the pie slices to 60px. The remaining space in
            // the chart will be left as a hole in the center.
            //
            // [ArcLabelDecorator] will automatically position the label inside the
            // arc if the label will fit. If the label will not fit, it will draw
            // outside of the arc with a leader line. Labels can always display
            // inside or outside using [LabelPosition].
            //
            // Text style for inside / outside can be controlled independently by
            // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
            //
            // Example configuring different styles for inside/outside:
            //       new charts.ArcLabelDecorator(
            //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
            //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 80,
                arcRendererDecorators: [new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside
                )
                ]))
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: buildContent()
      ),
    );
  }
}
