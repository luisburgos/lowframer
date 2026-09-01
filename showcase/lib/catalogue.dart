import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/pages/box_page.dart';
import 'package:lowframer_showcase/pages/palette_page.dart';
import 'package:lowframer_showcase/pages/scribble_page.dart';
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
    title: 'Window & cover',
    subtitle: 'The fixed canvas art is drawn on, and the panel it sits on',
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
    title: 'Art gallery',
    subtitle: 'Six compositions, repainted live by a palette playground',
    coverArt: (_) => const LowframerCover(child: ProfileFormArt()),
    builder: (_) => const _PaletteGalleryRoute(),
  ),
];

/// Routes to the palette gallery, which needs the app-level seed wiring.
///
/// A placeholder resolved in `main.dart`, where that state lives; kept here so
/// the catalogue stays one flat list of entries.
class _PaletteGalleryRoute extends StatelessWidget {
  const _PaletteGalleryRoute();

  @override
  Widget build(BuildContext context) =>
      ExampleRouteScope.of(context).paletteGallery(context);
}

/// Supplies the example routes that need app-level state.
///
/// The palette gallery drives the app's seed color and theme mode, which live
/// above the catalogue. Rather than thread that state through every entry, the
/// app scopes a builder here and the catalogue calls it.
class ExampleRouteScope extends InheritedWidget {
  /// Scopes [paletteGallery] over [child].
  const ExampleRouteScope({
    required this.paletteGallery,
    required super.child,
    super.key,
  });

  /// Builds the palette gallery page, wired to the app's state.
  final WidgetBuilder paletteGallery;

  /// The ambient scope. Throws when absent, which is a wiring bug.
  static ExampleRouteScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ExampleRouteScope>();
    assert(scope != null, 'No ExampleRouteScope in scope');
    return scope!;
  }

  @override
  bool updateShouldNotify(ExampleRouteScope oldWidget) =>
      paletteGallery != oldWidget.paletteGallery;
}
