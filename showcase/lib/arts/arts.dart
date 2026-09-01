import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';

/// A pill at [fraction] of the available width.
///
/// The arts were written against a 140px content box — the desktop frame's
/// inner width — so every absolute width silently assumed it. A fraction
/// scales to whatever frame the art is drawn at.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.color,
    required this.fraction,
    this.height = 12,
    this.borderColor,
  });

  final Color color;
  final double fraction;
  final double height;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: fraction,
      child: LowframerBox.pill(
        color: color,
        borderColor: borderColor,
        width: double.infinity,
        height: height,
      ),
    );
  }
}

/// A text-placeholder line at [fraction] of the available width.
class _Line extends StatelessWidget {
  const _Line({required this.color, required this.fraction});

  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: fraction,
      child: LowframerBox(color: color),
    );
  }
}

/// A chat bubble at [fraction] of the available width.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, required this.fraction});

  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: fraction,
      child: LowframerBox(color: color, height: 12),
    );
  }
}

/// A scribble at [fraction] of the available width.
class _Scribble extends StatelessWidget {
  const _Scribble({
    required this.color,
    required this.fraction,
    this.height = 8,
    this.strokeWidth = 2,
    this.wavelength = 10,
    this.seed = 0,
  });

  final Color color;
  final double fraction;
  final double height;
  final double strokeWidth;
  final double wavelength;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => LowframerScribble(
        color: color,
        width: constraints.maxWidth * fraction,
        height: height,
        strokeWidth: strokeWidth,
        wavelength: wavelength,
        seed: seed,
      ),
    );
  }
}

/// A miniature "buttons" illustration: pill silhouettes, one accent.
class ButtonsArt extends StatelessWidget {
  const ButtonsArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          _Pill(color: palette.accent, fraction: 0.5, height: 16),
          _Pill(color: palette.fill, fraction: 0.7, height: 16),
          _Pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            fraction: 0.4,
            height: 16,
          ),
        ],
      ),
    );
  }
}

/// A miniature "typography" illustration: scribbles of falling weight.
class TypographyArt extends StatelessWidget {
  const TypographyArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          // A scribble needs an explicit width, so each is sized to a
          // fraction of the row rather than to the desktop frame's 140.
          _Scribble(
            color: palette.accent,
            fraction: 0.55,
            height: 11,
            strokeWidth: 3,
            wavelength: 16,
            seed: 1,
          ),
          _Scribble(
            color: palette.fillStrong,
            fraction: 0.72,
            wavelength: 11,
            seed: 2,
          ),
          _Scribble(
            color: palette.fill,
            fraction: 0.85,
            height: 5,
            strokeWidth: 1.5,
            wavelength: 7,
            seed: 3,
          ),
        ],
      ),
    );
  }
}

/// A miniature profile form: avatar, labeled fields, accent submit.
class ProfileFormArt extends StatelessWidget {
  const ProfileFormArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(
                color: palette.fillStrong,
                width: 18,
                height: 18,
              ),
              // Expanded: the Column inherits the Row's unbounded width, so
              // a fraction inside it has nothing to be a fraction of.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    _Line(color: palette.fillStrong, fraction: 0.7),
                    _Line(color: palette.fill, fraction: 0.48),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _Line(color: palette.fillStrong, fraction: 0.2),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const SizedBox(height: 5),
          _Line(color: palette.fillStrong, fraction: 0.26),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: _Pill(color: palette.accent, fraction: 0.32),
          ),
        ],
      ),
    );
  }
}

/// A miniature dashboard: top bar, stat tiles, bars, list lines.
class DashboardArt extends StatelessWidget {
  const DashboardArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Expanded first: a fraction needs a bounded width, and a Row
              // gives its children none.
              Expanded(
                child: _Line(color: palette.fillStrong, fraction: 0.4),
              ),
              LowframerBox.pill(color: palette.fill, width: 10, height: 10),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            spacing: 6,
            children: [
              Expanded(
                child: LowframerBox(
                  color: palette.fill,
                  height: 18,
                  radius: 4,
                ),
              ),
              Expanded(
                child: LowframerBox(
                  color: palette.fill,
                  height: 18,
                  radius: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Flexible rather than fixed-width: a narrow frame would otherwise
          // overflow, and the bars' proportions carry the meaning, not their
          // absolute width.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              for (final (color, height) in <(Color, double)>[
                (palette.fill, 12),
                (palette.fill, 20),
                (palette.accent, 26),
                (palette.fill, 16),
              ])
                Flexible(
                  child: LowframerBox(color: color, height: height),
                ),
            ],
          ),
          const Spacer(),
          _Line(color: palette.fill, fraction: 0.68),
          const SizedBox(height: 3),
          _Line(color: palette.fill, fraction: 0.54),
        ],
      ),
    );
  }
}

/// A miniature chat thread: alternating bubbles and a compose bar.
class ChatThreadArt extends StatelessWidget {
  const ChatThreadArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _Bubble(color: palette.fill, fraction: 0.44),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: _Bubble(color: palette.accent, fraction: 0.34),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: _Bubble(color: palette.fill, fraction: 0.53),
          ),
          const Spacer(),
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: LowframerBox(
                  color: palette.background,
                  borderColor: palette.fillStrong,
                  height: 14,
                  radius: 7,
                ),
              ),
              LowframerBox.pill(color: palette.accent, width: 14, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// A miniature settings list: icon rows with toggles, one active.
class SettingsListArt extends StatelessWidget {
  const SettingsListArt({this.size = LowframerSizes.desktop, super.key});

  /// The footprint to frame this composition at.
  final Size size;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget row({required bool active}) => Row(
      spacing: 6,
      children: [
        LowframerBox.pill(color: palette.fill, width: 12),
        Expanded(
          child: _Line(
            color: active ? palette.fillStrong : palette.fill,
            fraction: 0.7,
          ),
        ),
        const Spacer(),
        LowframerBox.pill(
          color: active ? palette.accent : palette.fill,
          width: 20,
          height: 10,
        ),
      ],
    );

    return LowframerWindow(
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          _Line(color: palette.fillStrong, fraction: 0.3),
          row(active: true),
          row(active: false),
          row(active: false),
        ],
      ),
    );
  }
}
