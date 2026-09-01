import 'package:flutter/material.dart';
import 'package:lowframer/src/lowframer_palette.dart';

/// The corner radius of the window frame.
const double _kWindowRadius = 6;

/// The room a [LowframerCover] leaves around the window it centres.
const double _kCoverPadding = 30;

/// The corner radius of a [LowframerCover] panel.
const double _kCoverRadius = 16;

/// The shapes a [LowframerWindow] is worth sketching at.
///
/// Named constants rather than an enum: the size is an ordinary [Size] the
/// caller is free to choose, and these are the ones that come up. Following
/// Flutter's own `Durations` and `Colors`, a holder of related constants is an
/// `abstract final class`, not a type you can hold a value of.
///
/// The footprint stays fixed *per window* on purpose — art is an illustration
/// rather than a layout, and equal footprints keep compositions at the same
/// optical weight — but which footprint is the caller's call.
abstract final class LowframerSizes {
  /// Landscape, the shape a desktop or web view is sketched at.
  static const Size desktop = Size(160, 120);

  /// Squarer, for a tablet.
  static const Size tablet = Size(150, 140);

  /// Portrait, for a phone.
  static const Size mobile = Size(100, 170);
}

/// The full-width panel a piece of art sits on inside a card.
///
/// The panel is what makes the art read as a cover rather than a floating
/// glyph: a quiet wash the full width of the card, with the framed window
/// centered and lifted off it.
class LowframerCover extends StatelessWidget {
  /// {@macro lowframer_cover}
  const LowframerCover({
    required this.child,
    this.windowSize = LowframerSizes.desktop,
    super.key,
  });

  /// The framed art to center on the panel.
  final Widget child;

  /// The footprint of the window this panel holds.
  ///
  /// The panel's height derives from it, so a cover and its window cannot
  /// disagree: both read the same value. Pass what you gave the window.
  final Size windowSize;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: double.infinity,
      height: windowSize.height + _kCoverPadding,
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
  const LowframerWindow({
    required this.child,
    this.size = LowframerSizes.desktop,
    super.key,
  });

  /// The composition to frame.
  final Widget child;

  /// The window's footprint. See [LowframerSizes] for the usual shapes.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: size.width,
      height: size.height,
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
