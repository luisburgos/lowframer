import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';

// Cover art for the Examples entries.
//
// Each depicts the layout of its own page rather than borrowing one of the
// arts. An entry's tile is the only thing a reader sees before opening it, so
// a cover showing an unrelated composition says nothing about what the page
// does — which is what these replace.
//
// All three keep the LowframerWindow frame, so the Examples tiles still sit
// beside the Library ones as peers.

/// Theming: many compositions, one palette.
///
/// A grid of six tiny panels with a single accent among them, which is what
/// the page shows — six arts repainting together when the palette changes.
class ThemingCoverArt extends StatelessWidget {
  /// {@macro theming_cover_art}
  const ThemingCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          for (var row = 0; row < 2; row++)
            Row(
              spacing: 8,
              children: [
                for (var col = 0; col < 3; col++)
                  Expanded(
                    // One accented tile: the palette's emphasis colour is what
                    // a theme change moves most visibly.
                    child: LowframerBox(
                      color: row == 0 && col == 1
                          ? palette.accent
                          : palette.fill,
                      height: 32,
                      radius: 4,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Screen sketch: a whole screen at phone proportions.
///
/// A portrait slab with a header, rows and a footer bar — the outline of a
/// screen rather than a composition inside a window.
class ScreenSketchCoverArt extends StatelessWidget {
  /// {@macro screen_sketch_cover_art}
  const ScreenSketchCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    return LowframerWindow(
      child: Center(
        child: SizedBox(
          // Portrait inside a landscape frame: the page's subject is a screen
          // sketched at the proportions of a phone.
          width: 52,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: palette.background,
              border: Border.all(color: palette.border, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 5,
              children: [
                LowframerBox(color: palette.fillStrong),
                LowframerBox(color: palette.fill, height: 10),
                LowframerBox(color: palette.fill, height: 10),
                LowframerBox(color: palette.fill, height: 10),
                LowframerBox(color: palette.accent, height: 6, radius: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading skeleton: the placeholder beside what it stands in for.
///
/// Two panels at the same footprint — one of quiet placeholder rows, one with
/// the accent standing in for arrived content — which is the page's whole
/// comparison.
class SkeletonCoverArt extends StatelessWidget {
  /// {@macro skeleton_cover_art}
  const SkeletonCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget panel({required bool loaded}) => Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          for (var i = 0; i < 3; i++)
            Row(
              spacing: 5,
              children: [
                LowframerBox.pill(
                  color: loaded ? palette.accent : palette.fill,
                  width: 10,
                  height: 10,
                ),
                Expanded(
                  child: LowframerBox(
                    color: loaded ? palette.fillStrong : palette.fill,
                    height: 5,
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    return LowframerWindow(
      child: Row(
        spacing: 12,
        children: [panel(loaded: false), panel(loaded: true)],
      ),
    );
  }
}
