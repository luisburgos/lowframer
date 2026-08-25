import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';

void main() {
  group('LowframerScribble', () {
    testWidgets('lays out at its given size and paints a stroke', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: LowframerScribble(
              color: Colors.black,
              width: 60,
              height: 10,
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(LowframerScribble));
      expect(size, const Size(60, 10));
      expect(
        find.descendant(
          of: find.byType(LowframerScribble),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('repaints when a knob changes and not when identical', (
      tester,
    ) async {
      CustomPainter painterOf() => tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(LowframerScribble),
              matching: find.byType(CustomPaint),
            ),
          )
          .painter!;

      Widget build(double wavelength) => MaterialApp(
        home: Center(
          child: LowframerScribble(
            color: Colors.black,
            wavelength: wavelength,
          ),
        ),
      );

      await tester.pumpWidget(build(10));
      final first = painterOf();
      expect(first.shouldRepaint(first), isFalse);

      await tester.pumpWidget(build(4));
      final second = painterOf();
      expect(second.shouldRepaint(first), isTrue);
    });

    testWidgets('the wave style paints its irregular scrawl', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: LowframerScribble(
              color: Colors.black,
              style: LowframerScribbleStyle.wave,
            ),
          ),
        ),
      );

      expect(find.byType(LowframerScribble), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LowframerScribble),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('italic slants via fontStyle, mirroring TextStyle', (
      tester,
    ) async {
      CustomPainter painterOf() => tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(LowframerScribble),
              matching: find.byType(CustomPaint),
            ),
          )
          .painter!;

      Widget build(FontStyle fontStyle) => MaterialApp(
        home: Center(
          child: LowframerScribble(color: Colors.black, fontStyle: fontStyle),
        ),
      );

      await tester.pumpWidget(build(FontStyle.normal));
      final upright = painterOf();

      await tester.pumpWidget(build(FontStyle.italic));
      final italic = painterOf();

      expect(find.byType(LowframerScribble), findsOneWidget);
      expect(italic.shouldRepaint(upright), isTrue);
    });
  });
}
