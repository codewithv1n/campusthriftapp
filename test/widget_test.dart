// FILE: test/widget_test.dart

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const campusthrift() as Widget);

    // Verify that login screen shows CampusThrift title
    expect(find.text('CampusThrift'), findsOneWidget);

    // Verify that login button exists
    expect(find.text('Login'), findsOneWidget);
  });
}

// ignore: camel_case_types
class campusthrift {
  const campusthrift();
}
