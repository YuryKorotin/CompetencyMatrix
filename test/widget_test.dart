// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:competency_matrix/main.dart';

void main() {
  testWidgets('Await loading', (WidgetTester tester) async {
    await tester.pumpWidget(CompetencyMatrixApp());

    // Verify that title was showing.
    //expect(find.text("Programming"), findsOneWidget);
    expect(find.text('Matrices'), findsOneWidget);

    // Verify of showing info button
    await tester.tap(find.byIcon(Icons.info));
    await tester.pump();

    expect(find.text('COMPETENCY'), findsNothing);

    //await tester.tap(find.text("Done"));
    //await tester.pump();
    //expect(find.text("Creation"), findsWidgets);
  });

  testWidgets('Await creation', (WidgetTester tester) async {
    tester.binding.addTime(Duration(seconds: 7));

    await tester.pumpWidget(CompetencyMatrixApp());

    await tester.press(find.byType(FloatingActionButton));
    
    expect(find.text('Create'), findsOneWidget);
  });
}
