import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(home: Center(child: child));

  BoxDecoration decorationOf(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(LowframerBox),
        matching: find.byType(Container),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  group('LowframerBox', () {
    testWidgets('lays out at its given size with the given radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          const LowframerBox(
            color: Colors.black,
            width: 40,
            height: 20,
            radius: 6,
          ),
        ),
      );

      expect(tester.getSize(find.byType(LowframerBox)), const Size(40, 20));
      expect(
        decorationOf(tester).borderRadius,
        BorderRadius.circular(6),
      );
      expect(decorationOf(tester).border, isNull);
    });

    testWidgets('line is a short flat quiet box', (tester) async {
      await tester.pumpWidget(
        harness(const LowframerBox.line(color: Colors.black)),
      );

      expect(tester.getSize(find.byType(LowframerBox)), const Size(32, 4));
    });

    testWidgets('pill takes stadium radius and an optional border', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          const LowframerBox.pill(
            color: Colors.white,
            borderColor: Colors.black,
            width: 40,
          ),
        ),
      );

      expect(tester.getSize(find.byType(LowframerBox)), const Size(40, 12));
      expect(decorationOf(tester).borderRadius, BorderRadius.circular(999));
      expect(decorationOf(tester).border, isNotNull);
    });

    testWidgets('renders its child inside the shape', (tester) async {
      await tester.pumpWidget(
        harness(
          const LowframerBox(
            color: Colors.black,
            width: 40,
            height: 40,
            child: Text('x'),
          ),
        ),
      );

      expect(find.text('x'), findsOneWidget);
    });
  });
}
