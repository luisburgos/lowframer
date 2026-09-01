import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/pages/box_page.dart';
import 'package:lowframer_showcase/pages/palette_page.dart';
import 'package:lowframer_showcase/pages/screen_page.dart';
import 'package:lowframer_showcase/pages/scribble_page.dart';
import 'package:lowframer_showcase/pages/skeleton_page.dart';
import 'package:lowframer_showcase/pages/theming_page.dart';
import 'package:lowframer_showcase/pages/window_page.dart';
import 'package:showcaser/showcaser.dart';

/// The kit's primitives — one entry per thing you can construct.
///
/// Each routes to a playground, so the way to learn a primitive is to turn its
/// knobs rather than to read its arguments.
final libraryEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Box',
    subtitle: 'The one placeholder shape: line, pill, circle, field',
    coverArt: (_) => const LowframerCover(child: ButtonsArt()),
    builder: (_) => const BoxPage(),
  ),
  ShowcaseEntry(
    title: 'Scribble',
    subtitle: 'Written text: one continuous pen stroke, deterministic',
    coverArt: (_) => const LowframerCover(child: TypographyArt()),
    builder: (_) => const ScribblePage(),
  ),
  ShowcaseEntry(
    title: 'Frames',
    subtitle: 'The shapes art is drawn at, and the panel one sits on',
    coverArt: (_) => const LowframerCover(child: DashboardArt()),
    builder: (_) => const WindowPage(),
  ),
  ShowcaseEntry(
    title: 'Palette',
    subtitle: 'The six roles, derived from the theme or overridden',
    coverArt: (_) => const LowframerCover(child: SettingsListArt()),
    builder: (_) => const PalettePage(),
  ),
];

/// Finished compositions assembled from the primitives above.
///
/// An example earns a place here when the *composition* is the point — how the
/// primitives combine into something recognisable, or how a palette change
/// carries across a whole set at once.
final exampleEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Theming',
    subtitle: 'Derived from the app theme, or held against it',
    coverArt: (_) => const LowframerCover(child: ProfileFormArt()),
    builder: (_) => const ThemingPage(),
  ),
  ShowcaseEntry(
    title: 'Screen sketch',
    subtitle: 'A whole screen, at the size it would really render',
    coverArt: (_) => const LowframerCover(child: DashboardArt()),
    builder: (_) => const ScreenPage(),
  ),
  ShowcaseEntry(
    title: 'Loading skeleton',
    subtitle: 'The same primitives, shipping in a real loading state',
    coverArt: (_) => const LowframerCover(child: SettingsListArt()),
    builder: (_) => const SkeletonPage(),
  ),
];
