import 'package:competency_matrix/utils/color_pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:math' as Math;

class DiagramWidget extends StatelessWidget {
  Color labelColor = Colors.green[200];
  final _chartSize = const Size(200.0, 200.0);

  final Math.Random random = new Math.Random();

  List<CircularStackEntry> _buildKnowLedgeChartData() {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, Colors.red[200],
              rankKey: 'Data Structures'),
          new CircularSegmentEntry(1000.0, Colors.green[200],
              rankKey: 'Algorithms'),
          new CircularSegmentEntry(2000.0, Colors.blue[200],
              rankKey: 'Build Automation'),
          new CircularSegmentEntry(1000.0, Colors.yellow[200],
              rankKey: 'Automated Testing'),
          new CircularSegmentEntry(1000.0, Colors.yellow[200],
              rankKey: 'Automated Testing'),
        ],
        rankKey: 'Profession progress',
      ),
    ];

    return data;
  }

  List<CircularStackEntry> _buildRandomKnowledgeData() {
    int stackCount = random.nextInt(10);
    List<CircularStackEntry> data = new List.generate(stackCount, (i) {
      int segCount = random.nextInt(10);
      List<CircularSegmentEntry> segments = new List.generate(segCount, (j) {
        Color randomColor = ColorPalette.primary.random(random);
        return new CircularSegmentEntry(random.nextDouble(), randomColor);
      });
      return new CircularStackEntry(segments);
    });

    return data;
  }

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final Color color;

  DiagramWidget(this.color);

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));

    return new Scaffold(
      body: new Center(
        child: new AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData: _buildRandomKnowledgeData(),
          chartType: CircularChartType.Radial,
        ),
      ),
    );
  }
}
