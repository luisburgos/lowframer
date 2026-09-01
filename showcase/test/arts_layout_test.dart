import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';

void main() {
  // The arts were written against the desktop frame's 140px content box, and
  // only one of them failed loudly when other sizes arrived: a fraction with
  // no bounded ancestor throws in a Row but paints past the border in a
  // Column. This pumps every art at every size so the quiet ones are caught
  // too.
  testWidgets('every art lays out at every size', (tester) async {
    const arts = <String, Widget Function({Size size})>{
      'Buttons': ButtonsArt.new,
      'Typography': TypographyArt.new,
      'ProfileForm': ProfileFormArt.new,
      'Dashboard': DashboardArt.new,
      'ChatThread': ChatThreadArt.new,
      'SettingsList': SettingsListArt.new,
    };
    const sizes = {
      'desktop': LowframerSizes.desktop,
      'tablet': LowframerSizes.tablet,
      'mobile': LowframerSizes.mobile,
    };

    for (final art in arts.entries) {
      for (final size in sizes.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(child: art.value(size: size.value)),
          ),
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${art.key} threw at ${size.key}',
        );
      }
    }
  });
}
