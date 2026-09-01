import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// The state of the determinism preview.
class DeterminismConfig extends Equatable {
  /// Creates a determinism configuration.
  const DeterminismConfig({this.seed = 0, this.lines = 4});

  /// The seed every stroke is drawn from.
  final int seed;

  /// How many strokes are drawn.
  final int lines;

  /// A copy with the given fields replaced.
  DeterminismConfig copyWith({int? seed, int? lines}) =>
      DeterminismConfig(seed: seed ?? this.seed, lines: lines ?? this.lines);

  @override
  List<Object?> get props => [seed, lines];
}

const _presets = <PlaygroundPreset<DeterminismConfig>>[
  PlaygroundPreset(
    label: 'Seed 0',
    summary: 'The default handwriting.',
    config: DeterminismConfig(),
  ),
  PlaygroundPreset(
    label: 'Seed 3',
    summary: 'A different hand, and just as fixed.',
    config: DeterminismConfig(seed: 3),
  ),
];

/// Why the same input always paints the same pixels.
///
/// [LowframerScribble] looks random and is not: every irregularity comes from
/// a hash of the segment index and the seed, never from `math.Random`. That is
/// a contract, not an implementation detail — it is what lets a scribble sit
/// in a golden test without flaking.
///
/// Redraw forces a rebuild without changing the configuration. The strokes do
/// not move. Change the seed and every stroke changes at once, then holds.
class DeterminismPage extends StatefulWidget {
  /// Creates the determinism playground.
  const DeterminismPage({super.key});

  @override
  State<DeterminismPage> createState() => _DeterminismPageState();
}

class _DeterminismPageState extends State<DeterminismPage> {
  DeterminismConfig _config = const DeterminismConfig();

  /// Bumped by Redraw. Nothing reads it but the key, so a rebuild is all it
  /// causes — which is the point: the strokes must not care.
  int _redraws = 0;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<DeterminismConfig>(
      title: 'Determinism',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: 420,
      previewBuilder: (context, config) => _Strokes(
        // A new key each redraw forces the subtree to be rebuilt from
        // scratch, so the strokes are genuinely repainted rather than
        // retained. They still land in the same places.
        key: ValueKey(_redraws),
        config: config,
      ),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          StepKnob<int>(
            label: 'Seed',
            value: config.seed,
            values: const [0, 1, 2, 3, 4, 5],
            labelOf: (s) => '$s',
            onChanged: (v) => onChanged(config.copyWith(seed: v)),
          ),
          StepKnob<int>(
            label: 'Lines',
            value: config.lines,
            values: const [2, 3, 4, 5, 6],
            labelOf: (l) => '$l',
            onChanged: (v) => onChanged(config.copyWith(lines: v)),
          ),
          FilledButton.tonalIcon(
            onPressed: () => setState(() => _redraws++),
            icon: const Icon(Icons.refresh),
            label: Text('Redraw  ($_redraws)'),
          ),
          Text(
            'Redraw rebuilds the strokes from scratch. Nothing moves. '
            'Change the seed and every stroke changes at once, then holds.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Strokes extends StatelessWidget {
  const _Strokes({required this.config, super.key});

  final DeterminismConfig config;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          for (var i = 0; i < config.lines; i++)
            Row(
              spacing: 12,
              children: [
                // The seed each stroke is drawn from, stated beside it: two
                // lines with the same number are the same handwriting.
                SizedBox(
                  width: 20,
                  child: Text(
                    '${config.seed + i}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: LowframerScribble(
                    color: i.isEven ? palette.fillStrong : palette.fill,
                    width: 300,
                    height: 14,
                    wavelength: 14,
                    seed: config.seed + i,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
