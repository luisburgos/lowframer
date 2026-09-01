import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';

/// A miniature "buttons" illustration: pill silhouettes, one accent.
class ButtonsArt extends StatelessWidget {
  const ButtonsArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      frame: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.pill(color: palette.accent, width: 72, height: 16),
          LowframerBox.pill(color: palette.fill, width: 96, height: 16),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 56,
            height: 16,
          ),
        ],
      ),
    );
  }
}

/// A miniature "typography" illustration: scribbles of falling weight.
class TypographyArt extends StatelessWidget {
  const TypographyArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      frame: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          LowframerScribble(
            color: palette.accent,
            width: 76,
            height: 11,
            strokeWidth: 3,
            wavelength: 16,
            seed: 1,
          ),
          LowframerScribble(
            color: palette.fillStrong,
            width: 100,
            wavelength: 11,
            seed: 2,
          ),
          LowframerScribble(
            color: palette.fill,
            width: 118,
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
  const ProfileFormArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      frame: frame,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 44),
                  LowframerBox.line(color: palette.fill, width: 30),
                ],
              ),
            ],
          ),
          const Spacer(),
          LowframerBox.line(color: palette.fillStrong, width: 28),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const SizedBox(height: 5),
          LowframerBox.line(color: palette.fillStrong, width: 36),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox.pill(color: palette.accent, width: 44),
          ),
        ],
      ),
    );
  }
}

/// A miniature dashboard: top bar, stat tiles, bars, list lines.
class DashboardArt extends StatelessWidget {
  const DashboardArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      frame: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LowframerBox.line(color: palette.fillStrong, width: 34),
              const Spacer(),
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
          LowframerBox.line(color: palette.fill, width: 96),
          const SizedBox(height: 3),
          LowframerBox.line(color: palette.fill, width: 76),
        ],
      ),
    );
  }
}

/// A miniature chat thread: alternating bubbles and a compose bar.
class ChatThreadArt extends StatelessWidget {
  const ChatThreadArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      frame: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: LowframerBox(color: palette.fill, width: 62, height: 12),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox(color: palette.accent, width: 48, height: 12),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: LowframerBox(color: palette.fill, width: 74, height: 12),
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
  const SettingsListArt({this.frame = LowframerFrame.desktop, super.key});

  /// The shape to frame this composition at.
  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget row({required bool active}) => Row(
      spacing: 6,
      children: [
        LowframerBox.pill(color: palette.fill, width: 12),
        LowframerBox.line(
          color: active ? palette.fillStrong : palette.fill,
          width: 52,
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
      frame: frame,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 40),
          row(active: true),
          row(active: false),
          row(active: false),
        ],
      ),
    );
  }
}
