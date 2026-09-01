import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// What the rows are showing.
enum SkeletonState {
  /// Placeholders standing in for content that has not arrived.
  loading,

  /// The content itself.
  loaded,

  /// Both at once, for comparison.
  both,
}

/// The state of the skeleton preview.
class SkeletonConfig extends Equatable {
  /// Creates a skeleton configuration.
  const SkeletonConfig({
    this.state = SkeletonState.both,
    this.rows = 3,
    this.shimmer = true,
  });

  /// What the rows are showing.
  final SkeletonState state;

  /// How many rows are placed.
  final int rows;

  /// Whether the placeholders pulse.
  final bool shimmer;

  /// A copy with the given fields replaced.
  SkeletonConfig copyWith({
    SkeletonState? state,
    int? rows,
    bool? shimmer,
  }) => SkeletonConfig(
    state: state ?? this.state,
    rows: rows ?? this.rows,
    shimmer: shimmer ?? this.shimmer,
  );

  @override
  List<Object?> get props => [state, rows, shimmer];
}

const _presets = <PlaygroundPreset<SkeletonConfig>>[
  PlaygroundPreset(
    label: 'Side by side',
    summary: 'The placeholder and the content it stands in for.',
    config: SkeletonConfig(),
  ),
  PlaygroundPreset(
    label: 'Loading',
    summary: 'What a list looks like before its data arrives.',
    config: SkeletonConfig(state: SkeletonState.loading),
  ),
  PlaygroundPreset(
    label: 'Loaded',
    summary: 'The same rows, once the data is in.',
    config: SkeletonConfig(state: SkeletonState.loaded, shimmer: false),
  ),
];

/// The kit as a loading skeleton.
///
/// A box and a line standing in for content that has not arrived is exactly
/// what a skeleton loader is, so the same primitives that sketch a screen at
/// design time can ship in one. This is the only page where the art is not a
/// wireframe of something: it *is* the thing.
class SkeletonPage extends StatefulWidget {
  /// Creates the skeleton playground.
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  SkeletonConfig _config = const SkeletonConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<SkeletonConfig>(
      title: 'Loading skeleton',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: 420,
      previewBuilder: (context, config) => _Skeleton(config: config),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<SkeletonState>(
            label: 'State',
            value: config.state,
            values: SkeletonState.values,
            labelOf: (s) => s.name,
            onChanged: (v) => onChanged(config.copyWith(state: v)),
          ),
          StepKnob<int>(
            label: 'Rows',
            value: config.rows,
            values: const [1, 2, 3, 4, 5],
            labelOf: (r) => '$r',
            onChanged: (v) => onChanged(config.copyWith(rows: v)),
          ),
          SwitchKnob(
            label: 'Shimmer',
            value: config.shimmer,
            // A still placeholder is a legitimate choice, so the pulse is a
            // knob rather than a given.
            relevantWhen: KnobRelevance.when(
              isRelevant: config.state != SkeletonState.loaded,
              reason: 'Only the placeholders pulse.',
            ),
            onChanged: (v) => onChanged(config.copyWith(shimmer: v)),
          ),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.config});

  final SkeletonConfig config;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget panel({required String label, required Widget child}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.6,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: palette.background,
              border: Border.all(color: palette.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        ],
      ),
    );

    final placeholders = _Rows(
      count: config.rows,
      shimmer: config.shimmer,
      loaded: false,
    );
    final content = _Rows(count: config.rows, shimmer: false, loaded: true);

    return switch (config.state) {
      SkeletonState.loading => panel(label: 'Loading', child: placeholders),
      SkeletonState.loaded => panel(label: 'Loaded', child: content),
      SkeletonState.both => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          panel(label: 'Loading', child: placeholders),
          panel(label: 'Loaded', child: content),
        ],
      ),
    };
  }
}

/// The rows themselves, as placeholders or as content.
class _Rows extends StatelessWidget {
  const _Rows({
    required this.count,
    required this.shimmer,
    required this.loaded,
  });

  final int count;
  final bool shimmer;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    final theme = Theme.of(context);

    Widget row(int i) {
      if (loaded) {
        // The content the placeholder stands in for, at the same footprint.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                String.fromCharCode(65 + i),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Item ${i + 1}', style: theme.textTheme.labelLarge),
                  Text(
                    'Loaded from somewhere real',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          LowframerBox.pill(color: palette.fill, width: 28, height: 28),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                LowframerBox.line(color: palette.fillStrong, width: 76),
                LowframerBox(color: palette.fill, height: 8, radius: 4),
              ],
            ),
          ),
        ],
      );
    }

    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [for (var i = 0; i < count; i++) row(i)],
    );

    if (!shimmer) return rows;
    return _Pulse(child: rows);
  }
}

/// Fades its child in and out, the way a skeleton loader breathes.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.45).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}
