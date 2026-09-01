import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(home: Center(child: child));

  group('LowframerWindow', () {
    testWidgets('frames its child at the desktop footprint by default', (
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

    testWidgets('takes the footprint of the frame it is given', (tester) async {
      for (final frame in LowframerFrame.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: LowframerWindow(frame: frame, child: const SizedBox()),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(LowframerWindow)),
          frame.size,
          reason: '${frame.name} should frame at ${frame.size}',
        );
      }
    });
  });

  group('LowframerCover', () {
    testWidgets('spans the available width at the desktop panel height', (
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

    testWidgets('a cover grows with the frame it is given', (tester) async {
      // The panel derives its height from the frame, so a cover and the window
      // it holds cannot disagree.
      for (final frame in LowframerFrame.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: LowframerCover(frame: frame, child: const SizedBox()),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(LowframerCover)).height,
          greaterThan(frame.size.height),
          reason: '${frame.name} panel must clear its window',
        );
      }
    });
  });
}
