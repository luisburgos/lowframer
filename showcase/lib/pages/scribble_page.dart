import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:lowframer_showcase/components/scale_lookup.dart';
import 'package:playgrounder/playgrounder.dart';

/// The state of the [LowframerScribble] preview.
class ScribbleConfig extends Equatable {
  /// Creates a scribble configuration.
  const ScribbleConfig({
    this.width = 180,
    this.height = 12,
    this.strokeWidth = 2,
    this.wavelength = 10,
    this.seed = 0,
    this.italic = false,
    this.style = LowframerScribbleStyle.sketch,
    this.strong = false,
  });

  /// The line's length.
  final double width;

  /// The wave band's height.
  final double height;

  /// The pen thickness.
  final double strokeWidth;

  /// Pixels per full peak-and-valley cycle.
  final double wavelength;

  /// Varies the handwriting deterministically.
  final int seed;

  /// Whether the stroke slants, as a [FontStyle.italic] would.
  final bool italic;

  /// The handwriting style the stroke is drawn in.
  final LowframerScribbleStyle style;

  /// Whether the ink is the stronger fill rather than the quiet one.
  final bool strong;

  /// A copy with the given fields replaced.
  ScribbleConfig copyWith({
    double? width,
    double? height,
    double? strokeWidth,
    double? wavelength,
    int? seed,
    bool? italic,
    LowframerScribbleStyle? style,
    bool? strong,
  }) => ScribbleConfig(
    width: width ?? this.width,
    height: height ?? this.height,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    wavelength: wavelength ?? this.wavelength,
    seed: seed ?? this.seed,
    italic: italic ?? this.italic,
    style: style ?? this.style,
    strong: strong ?? this.strong,
  );

  @override
  List<Object?> get props => [
    width,
    height,
    strokeWidth,
    wavelength,
    seed,
    italic,
    style,
    strong,
  ];
}

/// The scales the knobs step along.
///
/// Declared once so the knob and the value it reports agree on each step's
/// name; see [stepFor].
const _heights = <ScaleStep>[
  ScaleStep('6', 6),
  ScaleStep('8', 8),
  ScaleStep('12', 12),
  ScaleStep('18', 18),
  ScaleStep('24', 24),
];
const _strokes = <ScaleStep>[
  ScaleStep('1.2', 1.2),
  ScaleStep('2', 2),
  ScaleStep('3', 3),
  ScaleStep('4', 4),
];
const _wavelengths = <ScaleStep>[
  ScaleStep('6', 6),
  ScaleStep('10', 10),
  ScaleStep('14', 14),
  ScaleStep('20', 20),
  ScaleStep('28', 28),
];
const _widths = <ScaleStep>[
  ScaleStep('80', 80),
  ScaleStep('120', 120),
  ScaleStep('180', 180),
  ScaleStep('240', 240),
];

/// Presets along the axis a reader picks first: what the handwriting is.
const _presets = <PlaygroundPreset<ScribbleConfig>>[
  PlaygroundPreset(
    label: 'Sketch',
    summary: 'A drawn wave: uniform rhythm, only a faint hand-tremor.',
    config: ScribbleConfig(),
  ),
  PlaygroundPreset(
    label: 'Scrawl',
    summary: 'Irregular handwriting: crests and cycles vary per segment.',
    config: ScribbleConfig(style: LowframerScribbleStyle.wave),
  ),
  PlaygroundPreset(
    label: 'Heading',
    summary: 'Thick and tall: a title standing in for large type.',
    config: ScribbleConfig(
      height: 18,
      strokeWidth: 4,
      wavelength: 20,
      strong: true,
    ),
  ),
  PlaygroundPreset(
    label: 'Caption',
    summary: 'Thin and tight: small print under a heading.',
    config: ScribbleConfig(height: 6, strokeWidth: 1.2, wavelength: 6),
  ),
  PlaygroundPreset(
    label: 'Cursive',
    summary: 'Slanted and lazy: wide cycles, leaning right.',
    config: ScribbleConfig(wavelength: 20, italic: true),
  ),
];

/// A playground for [LowframerScribble], the kit's written-text primitive.
class ScribblePage extends StatefulWidget {
  /// Creates the scribble playground.
  const ScribblePage({super.key});

  @override
  State<ScribblePage> createState() => _ScribblePageState();
}

class _ScribblePageState extends State<ScribblePage> {
  ScribbleConfig _config = const ScribbleConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<ScribbleConfig>(
      title: 'Scribble',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewBuilder: (context, config) {
        final palette = LowframerPalette.of(context);
        return LowframerWindow(
          child: Center(
            child: LowframerScribble(
              color: config.strong ? palette.fillStrong : palette.fill,
              width: config.width,
              height: config.height,
              strokeWidth: config.strokeWidth,
              wavelength: config.wavelength,
              seed: config.seed,
              fontStyle: config.italic ? FontStyle.italic : FontStyle.normal,
              style: config.style,
            ),
          ),
        );
      },
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<LowframerScribbleStyle>(
            label: 'Style',
            value: config.style,
            values: LowframerScribbleStyle.values,
            labelOf: (s) => s.name,
            onChanged: (v) => onChanged(config.copyWith(style: v)),
          ),
          KnobGroup(
            title: 'Writing',
            children: [
              ScaleKnob(
                label: 'Height',
                value: stepFor(_heights, config.height),
                values: _heights,
                onChanged: (v) => onChanged(config.copyWith(height: v.value)),
              ),
              ScaleKnob(
                label: 'Stroke',
                value: stepFor(_strokes, config.strokeWidth),
                values: _strokes,
                onChanged: (v) =>
                    onChanged(config.copyWith(strokeWidth: v.value)),
              ),
              ScaleKnob(
                label: 'Wavelength',
                value: stepFor(_wavelengths, config.wavelength),
                values: _wavelengths,
                onChanged: (v) =>
                    onChanged(config.copyWith(wavelength: v.value)),
              ),
              ScaleKnob(
                label: 'Width',
                value: stepFor(_widths, config.width),
                values: _widths,
                onChanged: (v) => onChanged(config.copyWith(width: v.value)),
              ),
            ],
          ),
          KnobGroup(
            title: 'Hand',
            children: [
              // The seed is what makes two lines with identical knobs read as
              // different sentences, so it is a knob rather than a constant.
              StepKnob<int>(
                label: 'Seed',
                value: config.seed,
                values: const [0, 1, 2, 3, 4, 5],
                labelOf: (s) => '$s',
                onChanged: (v) => onChanged(config.copyWith(seed: v)),
              ),
              SwitchKnob(
                label: 'Italic',
                value: config.italic,
                onChanged: (v) => onChanged(config.copyWith(italic: v)),
              ),
              SwitchKnob(
                label: 'Strong ink',
                value: config.strong,
                onChanged: (v) => onChanged(config.copyWith(strong: v)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
