import 'package:flutter_test/flutter_test.dart';
import 'package:try2/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // اختبار بسيط لتأكد من تشغيل التطبيق
    await tester.pumpWidget(const RahhalApp());
  });
}