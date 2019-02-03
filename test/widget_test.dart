// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:competency_matrix/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    //TODO: Add separate method for build fixture items
    await tester.pumpWidget(CompetencyMatrixApp());

    // Verify that our counter starts at 0.
    //expect(find.text('0'), findsOneWidget);
    //expect(find.text('1'), findsNothing);

    // TODO: Test adding new item
    //await tester.tap(find.byIcon(Icons.add));
    //await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text("programming"), findsWidgets);
  });
}
