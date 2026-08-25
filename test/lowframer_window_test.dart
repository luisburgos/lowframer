import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(home: Center(child: child));

  group('LowframerWindow', () {
    testWidgets('frames its child at the fixed 160x120 footprint', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(const LowframerWindow(child: Text('art'))),
      );

      expect(
        tester.getSize(find.byType(LowframerWindow)),
        const Size(160, 120),
      );
      expect(find.text('art'), findsOneWidget);
    });
  });

  group('LowframerCover', () {
    testWidgets('spans the available width at the fixed panel height', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          const SizedBox(
            width: 400,
            child: LowframerCover(child: Text('art')),
          ),
        ),
      );

      expect(tester.getSize(find.byType(LowframerCover)), const Size(400, 150));
      expect(find.text('art'), findsOneWidget);
    });
  });
}
