import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_example/arts/arts.dart';
import 'package:lowframer_example/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// The state of the palette preview.
class PaletteConfig extends Equatable {
  /// Creates a palette configuration.
  const PaletteConfig({this.showRoles = true, this.dimmed = false});

  /// Whether the six roles are listed as labelled swatches.
  final bool showRoles;

  /// Whether the accent is muted down to the quiet fill.
  ///
  /// The kit's one rule about accent is that it is used sparingly; this shows
  /// what a composition looks like with it withheld entirely.
  final bool dimmed;

  /// A copy with the given fields replaced.
  PaletteConfig copyWith({bool? showRoles, bool? dimmed}) => PaletteConfig(
    showRoles: showRoles ?? this.showRoles,
    dimmed: dimmed ?? this.dimmed,
  );

  @override
  List<Object?> get props => [showRoles, dimmed];
}

const _presets = <PlaygroundPreset<PaletteConfig>>[
  PlaygroundPreset(
    label: 'Roles',
    summary: 'The six roles a composition paints with, named.',
    config: PaletteConfig(),
  ),
  PlaygroundPreset(
    label: 'In use',
    summary: 'The same palette as a finished composition reads it.',
    config: PaletteConfig(showRoles: false),
  ),
];

/// A playground for [LowframerPalette], the six roles art is painted with.
///
/// The palette is derived from the ambient `ColorScheme`, so the seed picker
/// and the light/dark toggle on the index change what is shown here — which
/// is the point: the art follows the app's theme with no extra code.
class PalettePage extends StatefulWidget {
  /// Creates the palette playground.
  const PalettePage({super.key});

  @override
  State<PalettePage> createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> {
  PaletteConfig _config = const PaletteConfig();

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<PaletteConfig>(
      title: 'Palette',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: 360,
      previewBuilder: (context, config) {
        final base = LowframerPalette.of(context);
        final palette = config.dimmed
            ? base.copyWith(accent: base.fillStrong)
            : base;

        if (!config.showRoles) {
          return LowframerTheme(
            palette: palette,
            child: const LowframerCover(child: DashboardArt()),
          );
        }

        return LowframerTheme(
          palette: palette,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (name, color, note) in <(String, Color, String)>[
                ('backdrop', palette.backdrop, 'The cover panel wash'),
                ('background', palette.background, "The window's canvas"),
                ('border', palette.border, "The window's hairline frame"),
                ('fill', palette.fill, 'The quiet placeholder'),
                ('fillStrong', palette.fillStrong, 'Reads above fill'),
                ('accent', palette.accent, 'Emphasis, used sparingly'),
              ])
                _RoleRow(name: name, color: color, note: note),
            ],
          ),
        );
      },
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SwitchKnob(
            label: 'Show roles',
            value: config.showRoles,
            onChanged: (v) => onChanged(config.copyWith(showRoles: v)),
          ),
          SwitchKnob(
            label: 'Mute the accent',
            value: config.dimmed,
            onChanged: (v) => onChanged(config.copyWith(dimmed: v)),
          ),
        ],
      ),
    );
  }
}

/// One palette role: a swatch, its name, and what it is for.
class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.name,
    required this.color,
    required this.note,
  });

  final String name;
  final Color color;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                Text(
                  note,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
