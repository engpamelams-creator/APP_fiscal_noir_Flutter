import 'package:flutter_test/flutter_test.dart';

import 'package:fiscal_noir/main.dart';

void main() {
  testWidgets('App renders Fiscal Noir text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FiscalNoirApp());

    // Verify that our app title is present.
    expect(find.text('Fiscal Noir'), findsOneWidget);
  });
}
