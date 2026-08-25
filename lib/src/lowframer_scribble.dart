import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lowframer/src/lowframer_box.dart';

/// How a [LowframerScribble] writes its line.
enum LowframerScribbleStyle {
  /// Irregular handwriting: crest heights and cycle widths vary per
  /// segment, like a quickly scribbled sentence.
  wave,

  /// A drawn wave: uniform rhythm and height, with only the faint tremor
  /// of a hand — the wave a marker draws, not a plotter.
  sketch,
}

/// A line of handwriting with no words in it.
///
/// Where [LowframerBox.line] stands in for typeset text, this stands in for
/// *written* text: one continuous wavy pen stroke running the full line, as
/// a scribbled sentence. [height] and [strokeWidth] together read as the
/// writing's size, and [wavelength] is its frequency — tight cycles scrawl,
/// wide ones read as lazy cursive. [seed] varies the handwriting, so two
/// lines with the same knobs still read as different sentences. [fontStyle]
/// mirrors [TextStyle.fontStyle]: italic slants the whole stroke.
///
/// Deterministic on purpose: every irregularity — amplitude, cycle width —
/// comes from a hash of the segment index and [seed],
/// not from randomness, so the same input always paints the same pixels and
/// tests stay stable.
class LowframerScribble extends StatelessWidget {
  /// {@macro lowframer_scribble}
  const LowframerScribble({
    required this.color,
    this.width = 48,
    this.height = 8,
    this.strokeWidth = 2,
    this.wavelength = 10,
    this.seed = 0,
    this.fontStyle = FontStyle.normal,
    this.style = LowframerScribbleStyle.sketch,
    super.key,
  }) : assert(wavelength > 0, 'wavelength must be positive'),
       assert(strokeWidth > 0, 'strokeWidth must be positive');

  /// The ink color.
  final Color color;

  /// The line's length.
  final double width;

  /// The wave band's height; the amplitude derives from this minus the
  /// stroke, so the ink never paints outside its box.
  final double height;

  /// The pen thickness.
  final double strokeWidth;

  /// Pixels per full peak-and-valley cycle, before per-cycle jitter.
  final double wavelength;

  /// Varies the handwriting deterministically; same seed, same stroke.
  final int seed;

  /// Mirrors [TextStyle.fontStyle]: [FontStyle.italic] slants the stroke.
  final FontStyle fontStyle;

  /// The handwriting style the stroke is drawn in.
  final LowframerScribbleStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ScribblePainter(
          color: color,
          strokeWidth: strokeWidth,
          wavelength: wavelength,
          seed: seed,
          fontStyle: fontStyle,
          style: style,
        ),
      ),
    );
  }
}

class _ScribblePainter extends CustomPainter {
  const _ScribblePainter({
    required this.color,
    required this.strokeWidth,
    required this.wavelength,
    required this.seed,
    required this.fontStyle,
    required this.style,
  });

  final Color color;
  final double strokeWidth;
  final double wavelength;
  final int seed;
  final FontStyle fontStyle;
  final LowframerScribbleStyle style;

  /// A deterministic hash in [0, 1) from a segment index and the seed — the
  /// shader-style fractional-sine trick, so no [math.Random] state is
  /// involved and identical input always yields identical output.
  double _hash(int i) {
    final v = math.sin(i * 12.9898 + seed * 78.233) * 43758.5453;
    return v - v.floorToDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height / 2;

    if (fontStyle == FontStyle.italic) {
      // Shear about the midline so the slant costs no horizontal drift: a
      // point at the midline stays put, crests lean right, valleys left —
      // the same oblique a TextStyle italic applies to upright glyphs.
      canvas
        ..translate(0, midY)
        ..transform((Matrix4.identity()..setEntry(0, 1, -0.3)).storage)
        ..translate(0, -midY);
    }

    final baseAmp = math.max(0, (size.height - strokeWidth) / 2).toDouble();
    final halfWave = wavelength / 2;
    final endX = size.width - strokeWidth / 2;

    // One unbroken stroke: the pen never lifts, so the line reads as a
    // single written sentence rather than separated fragments.
    var x = strokeWidth / 2;
    final path = Path()..moveTo(x, midY);
    var segment = 0;
    var up = true;
    var done = false;

    while (!done) {
      segment++;
      // Sketch keeps the rhythm uniform — only a faint hand-tremor on each
      // cycle — where wave varies both freely per segment.
      final (hwJitter, ampJitter) = switch (style) {
        LowframerScribbleStyle.wave => (
          0.7 + 0.6 * _hash(segment),
          0.45 + 0.55 * _hash(segment + 31),
        ),
        LowframerScribbleStyle.sketch => (
          0.94 + 0.12 * _hash(segment),
          0.88 + 0.12 * _hash(segment + 31),
        ),
      };
      final hw = halfWave * hwJitter;
      var nextX = x + hw;
      // The sentence runs the full line: the last curve stretches to the
      // edge rather than leaving a stub of empty space after it.
      if (nextX > endX - hw * 0.35) {
        nextX = endX;
        done = true;
      }
      final amp = baseAmp * ampJitter * (up ? -1 : 1);
      // The tremor: crest position and landing point shift by fractions of
      // a pixel, which is what separates drawn ink from plotted output.
      final wobbleX = (_hash(segment + 57) - 0.5) * hw * 0.15;
      final wobbleY = (_hash(segment + 91) - 0.5) * strokeWidth * 0.4;
      path.quadraticBezierTo(
        (x + nextX) / 2 + wobbleX,
        midY + amp * 2,
        nextX,
        midY + (done ? 0 : wobbleY),
      );
      x = nextX;
      up = !up;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScribblePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      wavelength != oldDelegate.wavelength ||
      seed != oldDelegate.seed ||
      fontStyle != oldDelegate.fontStyle ||
      style != oldDelegate.style;
}
