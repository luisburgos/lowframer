import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// The state of the frames preview.
class FramesConfig extends Equatable {
  /// Creates a frames configuration.
  const FramesConfig({this.frame = LowframerFrame.desktop});

  /// The shape the art is framed at.
  final LowframerFrame frame;

  /// A copy with the given fields replaced.
  FramesConfig copyWith({LowframerFrame? frame}) =>
      FramesConfig(frame: frame ?? this.frame);

  @override
  List<Object?> get props => [frame];
}

/// One preset per frame, because the frame is what varies.
const _presets = <PlaygroundPreset<FramesConfig>>[
  PlaygroundPreset(
    label: 'Desktop',
    summary: 'Landscape, the shape a desktop or web view is sketched at.',
    config: FramesConfig(),
  ),
  PlaygroundPreset(
    label: 'Tablet',
    summary: 'Squarer, for a tablet.',
    config: FramesConfig(frame: LowframerFrame.tablet),
  ),
  PlaygroundPreset(
    label: 'Mobile',
    summary: 'Portrait, for a phone.',
    config: FramesConfig(frame: LowframerFrame.mobile),
  ),
];

/// The frames a composition is drawn at, and the panel one sits on.
///
/// Both are shown together because the interesting thing is the
/// *relationship*: [LowframerCover] is a full-width panel that centres a
/// [LowframerWindow] on it, and its height derives from the same frame, so the
/// two cannot disagree. A toggle between them would hide that.
class WindowPage extends StatefulWidget {
  /// Creates the frames playground.
  const WindowPage({super.key});

  @override
  State<WindowPage> createState() => _WindowPageState();
}

class _WindowPageState extends State<WindowPage> {
  FramesConfig _config = const FramesConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<FramesConfig>(
      title: 'Frames',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: 560,
      previewBuilder: (context, config) => _Frames(frame: config.frame),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<LowframerFrame>(
            label: 'Frame',
            value: config.frame,
            values: LowframerFrame.values,
            labelOf: (f) =>
                '${f.name}  ${f.size.width.toInt()}×${f.size.height.toInt()}',
            onChanged: (v) => onChanged(config.copyWith(frame: v)),
          ),
        ],
      ),
    );
  }
}

class _Frames extends StatelessWidget {
  const _Frames({required this.frame});

  final LowframerFrame frame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget labelled({
      required String name,
      required String note,
      required Widget child,
    }) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(name, style: theme.textTheme.titleSmall),
          Text(
            note,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        labelled(
          name: 'Window',
          note:
              'A fixed '
              '${frame.size.width.toInt()}×${frame.size.height.toInt()} '
              'canvas. Every composition at a given frame carries the same '
              'optical weight.',
          // Aligned left rather than stretched: the window does not grow, and
          // centring it would hide that.
          child: Align(
            alignment: Alignment.centerLeft,
            child: DashboardArt(frame: frame),
          ),
        ),
        labelled(
          name: 'Cover',
          note:
              'A full-width panel with the window centred on it. Its height '
              'derives from the same frame, so the two cannot disagree.',
          child: LowframerCover(
            frame: frame,
            child: DashboardArt(frame: frame),
          ),
        ),
      ],
    );
  }
}
