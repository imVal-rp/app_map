import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_map/main.dart';

void main() {
  testWidgets('shows the map screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(FlutterMap), findsOneWidget);
  });
}