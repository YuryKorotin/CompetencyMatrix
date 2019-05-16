import 'package:competency_matrix/main.dart';
import 'package:competency_matrix/screens/matrix_detail_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: MatrixDetailCreationScreen(() => {}, BigInt.from(1)))
    );
    return testWidget;
  }

  testWidgets('Fill text fields', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(find.byType(TextFormField).at(0), 'Name');

    await tester.enterText(find.byType(TextFormField).at(1), 'Category');

    await tester.enterText(find.byType(TextFormField).at(2), 'Description');

  });

  testWidgets('Check items were rendered', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text("Creation of matrix"), findsOneWidget);

    expect(find.text("Create"), findsOneWidget);
  });
}
