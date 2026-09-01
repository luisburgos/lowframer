import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// Which skeleton is being drawn.
///
/// The presets vary this: each is a different placeholder built from the same
/// primitives, which is the thing being demonstrated. Whether the real content
/// is shown beside it is a knob, not a preset — that content is plain Material
/// and has no lowframer in it, so it is a point of comparison rather than a
/// configuration of the kit.
enum SkeletonShape {
  /// Avatar, title, and a line of body: a list of people or posts.
  list,

  /// A media block over two lines: a feed of cards.
  card,

  /// Label and value pairs: a details or profile pane.
  detail,

  /// A header row over body rows: tabular data.
  table,
}

/// The state of the skeleton preview.
class SkeletonConfig extends Equatable {
  /// Creates a skeleton configuration.
  const SkeletonConfig({
    this.shape = SkeletonShape.list,
    this.rows = 3,
    this.shimmer = true,
    this.showLoaded = true,
  });

  /// Which skeleton is drawn.
  final SkeletonShape shape;

  /// How many rows are placed.
  final int rows;

  /// Whether the placeholders pulse.
  final bool shimmer;

  /// Whether the real content is shown beside the placeholder.
  final bool showLoaded;

  /// A copy with the given fields replaced.
  SkeletonConfig copyWith({
    SkeletonShape? shape,
    int? rows,
    bool? shimmer,
    bool? showLoaded,
  }) => SkeletonConfig(
    shape: shape ?? this.shape,
    rows: rows ?? this.rows,
    shimmer: shimmer ?? this.shimmer,
    showLoaded: showLoaded ?? this.showLoaded,
  );

  @override
  List<Object?> get props => [shape, rows, shimmer, showLoaded];
}

/// One preset per skeleton, because the skeleton is what varies.
const _presets = <PlaygroundPreset<SkeletonConfig>>[
  PlaygroundPreset(
    label: 'List',
    summary: 'Avatar, title, body — a list of people or posts.',
    config: SkeletonConfig(),
  ),
  PlaygroundPreset(
    label: 'Card',
    summary: 'A media block over two lines, for a feed of cards.',
    config: SkeletonConfig(shape: SkeletonShape.card, rows: 2),
  ),
  PlaygroundPreset(
    label: 'Detail',
    summary: 'Label and value pairs, for a details or profile pane.',
    config: SkeletonConfig(shape: SkeletonShape.detail, rows: 4),
  ),
  PlaygroundPreset(
    label: 'Table',
    summary: 'A header row over body rows, for tabular data.',
    config: SkeletonConfig(shape: SkeletonShape.table, rows: 4),
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
      previewMaxWidth: 460,
      previewBuilder: (context, config) => _Skeleton(config: config),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<SkeletonShape>(
            label: 'Skeleton',
            value: config.shape,
            values: SkeletonShape.values,
            labelOf: (s) => s.name,
            onChanged: (v) => onChanged(config.copyWith(shape: v)),
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
            onChanged: (v) => onChanged(config.copyWith(shimmer: v)),
          ),
          SwitchKnob(
            // Not a preset: the loaded panel is plain Material with no
            // lowframer in it, so it is a point of comparison rather than a
            // configuration of the kit.
            label: 'Show what it stands in for',
            value: config.showLoaded,
            onChanged: (v) => onChanged(config.copyWith(showLoaded: v)),
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
    final theme = Theme.of(context);

    Widget panel({required String label, required Widget child}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
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

    final placeholder = _Placeholder(config: config);

    if (!config.showLoaded) {
      return Row(
        children: [panel(label: 'Loading', child: placeholder)],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        panel(label: 'Loading', child: placeholder),
        panel(
          label: 'Loaded',
          child: _Loaded(config: config),
        ),
      ],
    );
  }
}

/// The skeleton itself, drawn entirely from lowframer primitives.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.config});

  final SkeletonConfig config;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget row(int i) => switch (config.shape) {
      SkeletonShape.list => Row(
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
      ),
      SkeletonShape.card => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          LowframerBox(color: palette.fill, height: 56, radius: 6),
          LowframerBox.line(color: palette.fillStrong, width: 104),
          LowframerBox(color: palette.fill, height: 8, radius: 4),
        ],
      ),
      SkeletonShape.detail => Row(
        children: [
          LowframerBox.line(color: palette.fill, width: 52),
          const Spacer(),
          LowframerBox.line(color: palette.fillStrong, width: 76),
        ],
      ),
      SkeletonShape.table => Row(
        spacing: 10,
        children: [
          LowframerBox(
            color: i == 0 ? palette.fillStrong : palette.fill,
            width: 20,
            height: 8,
            radius: 4,
          ),
          Expanded(
            child: LowframerBox(
              color: i == 0 ? palette.fillStrong : palette.fill,
              height: 8,
              radius: 4,
            ),
          ),
          LowframerBox(
            color: i == 0 ? palette.fillStrong : palette.fill,
            width: 36,
            height: 8,
            radius: 4,
          ),
        ],
      ),
    };

    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: config.shape == SkeletonShape.detail ? 12 : 16,
      children: [for (var i = 0; i < config.rows; i++) row(i)],
    );

    if (!config.shimmer) return rows;
    return _Pulse(child: rows);
  }
}

/// The real content, at the same footprint.
///
/// Deliberately plain Material — no lowframer at all. It is here to be
/// compared against, not to demonstrate the kit.
class _Loaded extends StatelessWidget {
  const _Loaded({required this.config});

  final SkeletonConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget row(int i) => switch (config.shape) {
      SkeletonShape.list => Row(
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
      ),
      SkeletonShape.card => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Text('Card ${i + 1}', style: theme.textTheme.labelLarge),
          Text(
            'A body line that arrived with the data',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      SkeletonShape.detail => Row(
        children: [
          Text(
            ['Name', 'Role', 'Team', 'Joined', 'Location'][i % 5],
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            ['Ada', 'Engineer', 'Platform', '2019', 'Remote'][i % 5],
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
      SkeletonShape.table => Row(
        spacing: 10,
        children: [
          SizedBox(
            width: 20,
            child: Text('${i + 1}', style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              i == 0 ? 'Column' : 'Row ${i + 1}',
              style: i == 0
                  ? theme.textTheme.labelLarge
                  : theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            i == 0 ? 'Value' : '${i * 12}',
            style: i == 0
                ? theme.textTheme.labelLarge
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: config.shape == SkeletonShape.detail ? 12 : 16,
      children: [for (var i = 0; i < config.rows; i++) row(i)],
    );
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
