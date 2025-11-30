import 'package:flutter_test/flutter_test.dart';

import 'package:builder_pattern_demo/main.dart';

void main() {
  testWidgets('Builder Pattern Demo loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const BuilderPatternDemoApp());

    expect(find.text('Builder Pattern Demo'), findsOneWidget);
    expect(find.text('Builder Pattern'), findsOneWidget);
  });
}