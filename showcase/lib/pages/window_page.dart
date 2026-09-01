import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:lowframer_showcase/components/scale_lookup.dart';
import 'package:playgrounder/playgrounder.dart';

/// The widths a window is worth trying at.
const _widths = <ScaleStep>[
  ScaleStep('80', 80),
  ScaleStep('100', 100),
  ScaleStep('120', 120),
  ScaleStep('150', 150),
  ScaleStep('160', 160),
  ScaleStep('200', 200),
];

/// The heights a window is worth trying at.
const _heights = <ScaleStep>[
  ScaleStep('80', 80),
  ScaleStep('100', 100),
  ScaleStep('120', 120),
  ScaleStep('140', 140),
  ScaleStep('170', 170),
  ScaleStep('200', 200),
];

/// The state of the window preview.
class WindowConfig extends Equatable {
  /// Creates a window configuration.
  const WindowConfig({this.size = LowframerSizes.desktop});

  /// The footprint the art is framed at.
  final Size size;

  /// A copy with the given fields replaced.
  WindowConfig copyWith({double? width, double? height}) => WindowConfig(
    size: Size(width ?? size.width, height ?? size.height),
  );

  @override
  List<Object?> get props => [size];
}

/// One preset per shape, because the shape is what varies.
const _presets = <PlaygroundPreset<WindowConfig>>[
  PlaygroundPreset(
    label: 'Desktop',
    summary: 'Landscape, the shape a desktop or web view is sketched at.',
    config: WindowConfig(),
  ),
  PlaygroundPreset(
    label: 'Tablet',
    summary: 'Squarer, for a tablet.',
    config: WindowConfig(size: LowframerSizes.tablet),
  ),
  PlaygroundPreset(
    label: 'Mobile',
    summary: 'Portrait, for a phone.',
    config: WindowConfig(size: LowframerSizes.mobile),
  ),
];

/// The canvas a composition is drawn on, and the panel it sits on.
///
/// [LowframerCover] is a full-width panel that centres a [LowframerWindow] on
/// it, and derives its height from the same size — so the two cannot disagree.
/// The cover is a switch rather than a second column because it *wraps* the
/// window rather than standing beside it: turning it on adds the panel to what
/// is already there, which is what the relationship actually is.
class WindowPage extends StatefulWidget {
  /// Creates the window playground.
  const WindowPage({super.key});

  @override
  State<WindowPage> createState() => _WindowPageState();
}

class _WindowPageState extends State<WindowPage> {
  WindowConfig _config = const WindowConfig();

  // A view option, held beside the configuration rather than in it.
  bool _showCover = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<WindowConfig>(
      title: 'Window & cover',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: 560,
      // Whether the panel is shown is a view option, not part of the
      // configuration a preset describes, so it sits in the pinned footer and
      // stays put while you page through the shapes.
      footer: SwitchKnob(
        label: 'Show cover',
        value: _showCover,
        onChanged: (v) => setState(() => _showCover = v),
      ),
      previewBuilder: (context, config) =>
          _Preview(size: config.size, showCover: _showCover),
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Any size, not just the named ones: the package takes a plain
          // Size, and the presets are a convenience rather than a limit.
          ScaleKnob(
            label: 'Width',
            value: stepFor(_widths, config.size.width),
            values: _widths,
            onChanged: (v) => onChanged(config.copyWith(width: v.value)),
          ),
          ScaleKnob(
            label: 'Height',
            value: stepFor(_heights, config.size.height),
            values: _heights,
            onChanged: (v) => onChanged(config.copyWith(height: v.value)),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.size, required this.showCover});

  final Size size;
  final bool showCover;

  @override
  Widget build(BuildContext context) {
    final art = DashboardArt(size: size);

    // One subject, not two labelled columns: the cover is the window with a
    // panel around it, so showing them as peers made a composition read as a
    // comparison. The switch adds the panel to what is already there.
    return Align(
      alignment: Alignment.centerLeft,
      child: showCover ? LowframerCover(windowSize: size, child: art) : art,
    );
  }
}
