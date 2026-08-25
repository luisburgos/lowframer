import 'package:flutter/material.dart';
import 'package:lowframer/src/lowframer_palette.dart';

/// The fixed footprint of a [LowframerWindow], landscape orientation.
const Size _kWindowSize = Size(160, 120);

/// The corner radius of the window frame.
const double _kWindowRadius = 6;

/// The height of a [LowframerCover] panel.
const double _kCoverHeight = 150;

/// The corner radius of a [LowframerCover] panel.
const double _kCoverRadius = 16;

/// The full-width panel a piece of art sits on inside a card.
///
/// The panel is what makes the art read as a cover rather than a floating
/// glyph: a quiet wash the full width of the card, with the framed window
/// centered and lifted off it.
class LowframerCover extends StatelessWidget {
  /// {@macro lowframer_cover}
  const LowframerCover({required this.child, super.key});

  /// The framed art to center on the panel.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: double.infinity,
      height: _kCoverHeight,
      decoration: BoxDecoration(
        color: palette.backdrop,
        borderRadius: BorderRadius.circular(_kCoverRadius),
      ),
      child: Center(child: child),
    );
  }
}

/// The miniature framed canvas every piece of art draws inside.
///
/// Fixed-size on purpose: the art is an illustration, not a layout, and a
/// fixed frame keeps every composition the same optical weight.
class LowframerWindow extends StatelessWidget {
  /// {@macro lowframer_window}
  const LowframerWindow({required this.child, super.key});

  /// The composition to frame.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: _kWindowSize.width,
      height: _kWindowSize.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.border, width: 0.5),
        borderRadius: BorderRadius.circular(_kWindowRadius),
        // Lifts the window off the cover wash; near-invisible in dark, where
        // the surface-on-wash contrast already does the separating.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
