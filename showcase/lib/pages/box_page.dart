import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:lowframer_showcase/components/scale_lookup.dart';
import 'package:playgrounder/playgrounder.dart';

/// Which palette role a shape paints with.
///
/// The knobs offer roles rather than raw colors: a composition picks from the
/// palette so it follows the theme, and a color picker here would teach the
/// opposite of how the kit is meant to be used.
enum BoxRole {
  fill,
  fillStrong,
  accent,
  background;

  Color of(LowframerPalette palette) => switch (this) {
    BoxRole.fill => palette.fill,
    BoxRole.fillStrong => palette.fillStrong,
    BoxRole.accent => palette.accent,
    BoxRole.background => palette.background,
  };
}

/// The state of the [LowframerBox] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class BoxConfig extends Equatable {
  /// Creates a box configuration.
  const BoxConfig({
    this.width = 96,
    this.height = 16,
    this.radius = 2,
    this.role = BoxRole.fill,
    this.bordered = false,
  });

  /// The box width.
  final double width;

  /// The box height.
  final double height;

  /// The corner radius.
  final double radius;

  /// The palette role the box fills with.
  final BoxRole role;

  /// Whether a hairline border is drawn.
  final bool bordered;

  /// A copy with the given fields replaced.
  BoxConfig copyWith({
    double? width,
    double? height,
    double? radius,
    BoxRole? role,
    bool? bordered,
  }) => BoxConfig(
    width: width ?? this.width,
    height: height ?? this.height,
    radius: radius ?? this.radius,
    role: role ?? this.role,
    bordered: bordered ?? this.bordered,
  );

  @override
  List<Object?> get props => [width, height, radius, role, bordered];
}

/// The scales the knobs step along, declared once so the knob and the value
/// it reports agree on each step's name; see [stepFor].
const _widths = <ScaleStep>[
  ScaleStep('16', 16),
  ScaleStep('24', 24),
  ScaleStep('32', 32),
  ScaleStep('48', 48),
  ScaleStep('72', 72),
  ScaleStep('96', 96),
  ScaleStep('120', 120),
];
const _heights = <ScaleStep>[
  ScaleStep('4', 4),
  ScaleStep('8', 8),
  ScaleStep('12', 12),
  ScaleStep('16', 16),
  ScaleStep('24', 24),
  ScaleStep('32', 32),
];
const _radii = <ScaleStep>[
  ScaleStep('0', 0),
  ScaleStep('2', 2),
  ScaleStep('4', 4),
  ScaleStep('8', 8),
  ScaleStep('full', 999),
];

/// One preset per named constructor: the shapes the kit ships as shorthands.
const _presets = <PlaygroundPreset<BoxConfig>>[
  PlaygroundPreset(
    label: 'Box',
    summary: 'The default: a softly rounded rectangle.',
    config: BoxConfig(),
  ),
  PlaygroundPreset(
    label: 'Line',
    summary: 'A text placeholder — short, flat, quiet.',
    config: BoxConfig(width: 32, height: 4),
  ),
  PlaygroundPreset(
    label: 'Pill',
    summary: 'Stadium radius: the button and chip silhouette.',
    config: BoxConfig(width: 72, height: 12, radius: 999),
  ),
  PlaygroundPreset(
    label: 'Circle',
    summary: 'A square at half its size in radius — an avatar or a dot.',
    config: BoxConfig(width: 24, height: 24, radius: 999),
  ),
  PlaygroundPreset(
    label: 'Outlined',
    summary: 'A hairline border over the canvas: an empty field.',
    config: BoxConfig(
      radius: 4,
      role: BoxRole.background,
      bordered: true,
    ),
  ),
];

/// A playground for [LowframerBox], the kit's one placeholder shape.
class BoxPage extends StatefulWidget {
  /// Creates the box playground.
  const BoxPage({super.key});

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {
  BoxConfig _config = const BoxConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<BoxConfig>(
      title: 'Box',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewBuilder: (context, config) {
        final palette = LowframerPalette.of(context);
        // Framed in a window so the shape is read at the scale it is drawn
        // at, against the canvas it is drawn on.
        return LowframerWindow(
          child: Center(
            child: LowframerBox(
              color: config.role.of(palette),
              width: config.width,
              height: config.height,
              radius: config.radius,
              borderColor: config.bordered ? palette.fillStrong : null,
            ),
          ),
        );
      },
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          ScaleKnob(
            label: 'Width',
            value: stepFor(_widths, config.width),
            values: _widths,
            onChanged: (v) => onChanged(config.copyWith(width: v.value)),
          ),
          ScaleKnob(
            label: 'Height',
            value: stepFor(_heights, config.height),
            values: _heights,
            onChanged: (v) => onChanged(config.copyWith(height: v.value)),
          ),
          ScaleKnob(
            label: 'Radius',
            value: stepFor(_radii, config.radius),
            values: _radii,
            onChanged: (v) => onChanged(config.copyWith(radius: v.value)),
          ),
          DropdownKnob<BoxRole>(
            label: 'Fill role',
            value: config.role,
            values: BoxRole.values,
            labelOf: (r) => r.name,
            onChanged: (v) => onChanged(config.copyWith(role: v)),
          ),
          SwitchKnob(
            label: 'Bordered',
            value: config.bordered,
            onChanged: (v) => onChanged(config.copyWith(bordered: v)),
          ),
        ],
      ),
    );
  }
}
