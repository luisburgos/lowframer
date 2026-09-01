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

    testWidgets('takes the footprint it is given', (tester) async {
      const sizes = [
        LowframerSizes.desktop,
        LowframerSizes.tablet,
        LowframerSizes.mobile,
        // An arbitrary size: the named ones are a convenience, not a limit.
        Size(200, 80),
      ];

      for (final size in sizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: LowframerWindow(size: size, child: const SizedBox()),
            ),
          ),
        );

        expect(tester.getSize(find.byType(LowframerWindow)), size);
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

    testWidgets('grows with the window size it is given', (tester) async {
      // The panel derives its height from the size, so a cover and the window
      // it holds cannot disagree.
      const sizes = [
        LowframerSizes.desktop,
        LowframerSizes.tablet,
        LowframerSizes.mobile,
      ];

      for (final size in sizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: LowframerCover(
                windowSize: size,
                child: const SizedBox(),
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(LowframerCover)).height,
          greaterThan(size.height),
          reason: 'the panel must clear a $size window',
        );
      }
    });
  });
}
