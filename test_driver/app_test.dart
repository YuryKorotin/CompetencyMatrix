import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Competency Matrix App', () {
    final infoIconFinder = find.byValueKey('info_icon');
    final submitCreationFinder = find.byValueKey('submit_creation_key');
    final newMatrixButtonFinder = find.byValueKey('create_new_key');
    final headerTextFinder = find.byValueKey('header_item_key');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Loading finished with matrix', () async {
      expect(await driver.getText(headerTextFinder), "Programming");
    });

    test('Opening info view', () async {
      // First, tap on the button
      await driver.tap(infoIconFinder);

      //expect(await driver.getText(counterTextFinder), "1");
    });

    test('Opening matrix creation screen', () async {
      // First, tap on the button
      await driver.tap(newMatrixButtonFinder);

      expect(await driver.getText(submitCreationFinder), "Create");
    });
  });
}