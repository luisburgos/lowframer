import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';

void main() {
  group('LowframerPalette', () {
    Future<LowframerPalette> paletteUnder(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      late LowframerPalette palette;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) {
              palette = LowframerPalette.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      // A theme swap animates through AnimatedTheme; settle so the palette
      // reads the final theme, not a mid-lerp frame.
      await tester.pumpAndSettle();
      return palette;
    }

    testWidgets('derives every role from the ambient ColorScheme', (
      tester,
    ) async {
      final theme = ThemeData.light();
      final palette = await paletteUnder(tester, theme);
      final scheme = theme.colorScheme;

      expect(palette.background, scheme.surface);
      expect(palette.border, scheme.outlineVariant);
      expect(palette.accent, scheme.primary);
      expect(palette.backdrop, scheme.onSurface.withValues(alpha: 0.05));
      expect(palette.fill, scheme.onSurface.withValues(alpha: 0.14));
      expect(palette.fillStrong, scheme.onSurface.withValues(alpha: 0.35));
    });

    testWidgets('light and dark themes yield distinct palettes', (
      tester,
    ) async {
      final light = await paletteUnder(tester, ThemeData.light());
      final dark = await paletteUnder(tester, ThemeData.dark());

      expect(light.background, isNot(dark.background));
      expect(light.fill, isNot(dark.fill));
    });

    test('copyWith replaces only the given roles', () {
      const base = LowframerPalette(
        backdrop: Colors.grey,
        background: Colors.white,
        border: Colors.black12,
        fill: Colors.black26,
        fillStrong: Colors.black54,
        accent: Colors.black,
      );

      final copy = base.copyWith(accent: Colors.red);

      expect(copy.accent, Colors.red);
      expect(copy.background, base.background);
      expect(copy.fill, base.fill);
      expect(base.copyWith(), base);
    });

    test('value equality covers every role', () {
      const a = LowframerPalette(
        backdrop: Colors.grey,
        background: Colors.white,
        border: Colors.black12,
        fill: Colors.black26,
        fillStrong: Colors.black54,
        accent: Colors.black,
      );

      expect(a, a.copyWith());
      expect(a.hashCode, a.copyWith().hashCode);
      expect(a, isNot(a.copyWith(border: Colors.red)));
    });
  });

  group('LowframerTheme', () {
    const custom = LowframerPalette(
      backdrop: Color(0x11000000),
      background: Color(0xFFFDF6EC),
      border: Color(0xFFE3D5C0),
      fill: Color(0x3D704214),
      fillStrong: Color(0x8A704214),
      accent: Color(0xFF9C4221),
    );

    testWidgets('overrides the derived palette for the subtree', (
      tester,
    ) async {
      late LowframerPalette resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: LowframerTheme(
            palette: custom,
            child: Builder(
              builder: (context) {
                resolved = LowframerPalette.of(context);
                return const LowframerWindow(child: SizedBox());
              },
            ),
          ),
        ),
      );

      expect(resolved, custom);

      // The window resolves through the same lookup, so the override reaches
      // its canvas without being passed explicitly.
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(LowframerWindow),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, custom.background);
    });

    testWidgets('notifies dependents only when the palette changes', (
      tester,
    ) async {
      Widget build(LowframerPalette palette) => MaterialApp(
        home: LowframerTheme(
          palette: palette,
          child: const LowframerWindow(child: SizedBox()),
        ),
      );

      await tester.pumpWidget(build(custom));
      final theme = tester.widget<LowframerTheme>(
        find.byType(LowframerTheme),
      );

      expect(theme.updateShouldNotify(theme), isFalse);

      await tester.pumpWidget(
        build(custom.copyWith(accent: const Color(0xFF000000))),
      );
      final updated = tester.widget<LowframerTheme>(
        find.byType(LowframerTheme),
      );
      expect(updated.updateShouldNotify(theme), isTrue);
    });
  });
}
