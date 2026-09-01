import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// Which screen is sketched.
enum ScreenKind {
  /// A scrolling list of posts.
  feed,

  /// Grouped rows with trailing controls.
  settings,

  /// A header over a two-column stat grid.
  dashboard,
}

/// How much room the rows are given.
enum ScreenDensity {
  /// Tighter rows, more of them visible.
  compact,

  /// The resting spacing.
  regular,

  /// Looser rows, fewer visible.
  relaxed;

  /// The vertical gap between rows at this density.
  double get gap => switch (this) {
    ScreenDensity.compact => 8,
    ScreenDensity.regular => 14,
    ScreenDensity.relaxed => 22,
  };
}

/// The state of the screen sketch.
class ScreenConfig extends Equatable {
  /// Creates a screen configuration.
  const ScreenConfig({
    this.kind = ScreenKind.feed,
    this.density = ScreenDensity.regular,
    this.accented = true,
  });

  /// Which screen is sketched.
  final ScreenKind kind;

  /// How much room the rows are given.
  final ScreenDensity density;

  /// Whether the one accent is placed at all.
  ///
  /// The kit's rule about accent is that it is used sparingly; turning it off
  /// shows what a screen reads like with the emphasis withheld entirely.
  final bool accented;

  /// A copy with the given fields replaced.
  ScreenConfig copyWith({
    ScreenKind? kind,
    ScreenDensity? density,
    bool? accented,
  }) => ScreenConfig(
    kind: kind ?? this.kind,
    density: density ?? this.density,
    accented: accented ?? this.accented,
  );

  @override
  List<Object?> get props => [kind, density, accented];
}

const _presets = <PlaygroundPreset<ScreenConfig>>[
  PlaygroundPreset(
    label: 'Feed',
    summary: 'A scrolling list of posts, each with an avatar and a body.',
    config: ScreenConfig(),
  ),
  PlaygroundPreset(
    label: 'Settings',
    summary: 'Grouped rows, each with a trailing control.',
    config: ScreenConfig(kind: ScreenKind.settings),
  ),
  PlaygroundPreset(
    label: 'Dashboard',
    summary: 'A header over a grid of stat tiles.',
    config: ScreenConfig(kind: ScreenKind.dashboard),
  ),
];

/// A whole screen sketched at the size it would really render.
///
/// Every other page draws art inside a [LowframerWindow], a fixed 160x120
/// miniature. This one drops the frame and lets the primitives lay out at
/// screen scale, which is what the kit is actually for: sketching a layout
/// before the layout exists.
class ScreenPage extends StatefulWidget {
  /// Creates the screen playground.
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  ScreenConfig _config = const ScreenConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<ScreenConfig>(
      title: 'Screen sketch',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      // Clamped to a phone's width: a sketch of a screen should be read at
      // the proportions of one.
      previewMaxWidth: 340,
      previewBuilder: (context, config) => _Screen(config: config),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<ScreenKind>(
            label: 'Screen',
            value: config.kind,
            values: ScreenKind.values,
            labelOf: (k) => k.name,
            onChanged: (v) => onChanged(config.copyWith(kind: v)),
          ),
          DropdownKnob<ScreenDensity>(
            label: 'Density',
            value: config.density,
            values: ScreenDensity.values,
            labelOf: (d) => d.name,
            onChanged: (v) => onChanged(config.copyWith(density: v)),
          ),
          SwitchKnob(
            label: 'Place the accent',
            value: config.accented,
            onChanged: (v) => onChanged(config.copyWith(accented: v)),
          ),
        ],
      ),
    );
  }
}

/// The sketch itself: chrome, then whichever body the config asks for.
class _Screen extends StatelessWidget {
  const _Screen({required this.config});

  final ScreenConfig config;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    final accent = config.accented ? palette.accent : palette.fillStrong;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // An app bar: a title with an action at the far end.
          Row(
            children: [
              LowframerBox.line(color: palette.fillStrong, width: 72),
              const Spacer(),
              LowframerBox.pill(color: palette.fill, width: 14, height: 14),
            ],
          ),
          SizedBox(height: config.density.gap + 6),
          switch (config.kind) {
            ScreenKind.feed => _Feed(gap: config.density.gap, accent: accent),
            ScreenKind.settings => _Settings(
              gap: config.density.gap,
              accent: accent,
            ),
            ScreenKind.dashboard => _Dashboard(
              gap: config.density.gap,
              accent: accent,
            ),
          },
        ],
      ),
    );
  }
}

class _Feed extends StatelessWidget {
  const _Feed({required this.gap, required this.accent});

  final double gap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget post({required bool accented}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        LowframerBox.pill(color: palette.fill, width: 28, height: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              LowframerBox.line(color: palette.fillStrong, width: 84),
              LowframerBox(color: palette.fill, height: 8, radius: 4),
              LowframerBox(color: palette.fill, height: 8, radius: 4),
              SizedBox(height: gap / 3),
              LowframerBox.pill(
                color: accented ? accent : palette.fill,
                width: 56,
                height: 14,
              ),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: gap,
      children: [
        post(accented: true),
        post(accented: false),
        post(accented: false),
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({required this.gap, required this.accent});

  final double gap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget row({required bool on}) => Row(
      spacing: 10,
      children: [
        LowframerBox.pill(color: palette.fill, width: 16, height: 16),
        LowframerBox.line(color: palette.fillStrong, width: 88),
        const Spacer(),
        LowframerBox.pill(
          color: on ? accent : palette.fill,
          width: 26,
          height: 14,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: gap,
      children: [
        LowframerBox.line(color: palette.fill, width: 44),
        row(on: true),
        row(on: false),
        SizedBox(height: gap / 2),
        LowframerBox.line(color: palette.fill, width: 52),
        row(on: false),
        row(on: true),
      ],
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.gap, required this.accent});

  final double gap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget tile({required bool accented}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          LowframerBox.line(color: palette.fill, width: 34),
          LowframerBox.pill(
            color: accented ? accent : palette.fillStrong,
            width: 52,
            height: 16,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: gap,
      children: [
        Row(
          spacing: 12,
          children: [tile(accented: true), tile(accented: false)],
        ),
        Row(
          spacing: 12,
          children: [tile(accented: false), tile(accented: false)],
        ),
        SizedBox(height: gap / 2),
        // A bar chart, one column emphasised.
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            LowframerBox(color: palette.fill, width: 18, height: 24),
            LowframerBox(color: palette.fill, width: 18, height: 40),
            LowframerBox(color: accent, width: 18, height: 56),
            LowframerBox(color: palette.fill, width: 18, height: 32),
            LowframerBox(color: palette.fill, width: 18, height: 44),
          ],
        ),
      ],
    );
  }
}
