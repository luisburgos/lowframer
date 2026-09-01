import 'package:flutter/material.dart';
import 'package:lowframer/src/lowframer_palette.dart';

/// The corner radius of the window frame.
const double _kWindowRadius = 6;

/// The room a [LowframerCover] leaves around the window it centres.
const double _kCoverPadding = 30;

/// The corner radius of a [LowframerCover] panel.
const double _kCoverRadius = 16;

/// The shape a [LowframerWindow] is framed at.
///
/// A named set rather than a free [Size]: the footprint is fixed on purpose,
/// because art is an illustration rather than a layout and equal footprints
/// keep every composition at the same optical weight. Arbitrary sizes would
/// give that up. These are the shapes worth sketching at.
enum LowframerFrame {
  /// Landscape, the shape a desktop or web view is sketched at.
  desktop(Size(160, 120)),

  /// Squarer, for a tablet.
  tablet(Size(150, 140)),

  /// Portrait, for a phone.
  mobile(Size(100, 170));

  const LowframerFrame(this.size);

  /// The window's footprint at this frame.
  final Size size;
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
    this.frame = LowframerFrame.desktop,
    super.key,
  });

  /// The framed art to center on the panel.
  final Widget child;

  /// The frame the art is drawn at.
  ///
  /// The panel's height derives from this, so a cover and the window it holds
  /// cannot disagree: both read the same source. Pass the frame you gave the
  /// window.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: double.infinity,
      height: frame.size.height + _kCoverPadding,
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
    this.frame = LowframerFrame.desktop,
    super.key,
  });

  /// The composition to frame.
  final Widget child;

  /// The shape to frame it at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: frame.size.width,
      height: frame.size.height,
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
