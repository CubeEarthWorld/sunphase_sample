import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sunphase_sample/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // アプリを構築し、フレームをトリガーします。
    await tester.pumpWidget(MyApp());  // const を削除

    // Verify that our counter starts at 0.
    // カウンターが 0 から始まることを確認します。
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // '+' アイコンをタップし、フレームを更新します。
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    // カウンターが増加したことを確認します。
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
