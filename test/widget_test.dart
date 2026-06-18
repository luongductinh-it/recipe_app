import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/app.dart';

void main() {
  testWidgets('App launches with splash page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Bắt đầu với những món ăn'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
  });
}
