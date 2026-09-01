import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:playgrounder/playgrounder.dart';

/// Custom palettes modeled on common terminal color styles.
///
/// Each shows [LowframerTheme] overriding the theme-derived palette: the art
/// keeps the terminal's look whatever the app theme does.
const _terminalPalettes = <String, LowframerPalette>{
  'Dracula': LowframerPalette(
    backdrop: Color(0x14BD93F9),
    background: Color(0xFF282A36),
    border: Color(0xFF44475A),
    fill: Color(0x26F8F8F2),
    fillStrong: Color(0x66F8F8F2),
    accent: Color(0xFFBD93F9),
  ),
  'Solarized Dark': LowframerPalette(
    backdrop: Color(0x14839496),
    background: Color(0xFF002B36),
    border: Color(0xFF0E4550),
    fill: Color(0x40839496),
    fillStrong: Color(0x99839496),
    accent: Color(0xFF268BD2),
  ),
  'Solarized Light': LowframerPalette(
    backdrop: Color(0x14657B83),
    background: Color(0xFFFDF6E3),
    border: Color(0xFFEEE8D5),
    fill: Color(0x33657B83),
    fillStrong: Color(0x80657B83),
    accent: Color(0xFFCB4B16),
  ),
  'Monokai': LowframerPalette(
    backdrop: Color(0x14F8F8F2),
    background: Color(0xFF272822),
    border: Color(0xFF49483E),
    fill: Color(0x26F8F8F2),
    fillStrong: Color(0x66F8F8F2),
    accent: Color(0xFFA6E22E),
  ),
  'Nord': LowframerPalette(
    backdrop: Color(0x14ECEFF4),
    background: Color(0xFF2E3440),
    border: Color(0xFF434C5E),
    fill: Color(0x26ECEFF4),
    fillStrong: Color(0x66ECEFF4),
    accent: Color(0xFF88C0D0),
  ),
};

/// The color grid offered by the custom palette's role pickers.
const _pickerColors = <Color>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lime,
  Colors.amber,
  Colors.orange,
  Colors.brown,
  Colors.white,
  Colors.black,
  Color(0xFFEEEEEE),
  Color(0xFF616161),
  Color(0x14000000),
  Color(0x26000000),
  Color(0x66000000),
  Color(0x26FFFFFF),
  Color(0x66FFFFFF),
];

/// Where the gallery's palette comes from — the playground's configuration.
///
/// The three cases are the three ways the arts can be colored: derived from the
/// app theme, one of the named terminal palettes, or a fully custom set of
/// roles. Value equality lets the playground tell which preset (if any) the
/// current configuration matches.
@immutable
sealed class _PaletteConfig {
  const _PaletteConfig();
}

/// Derive the palette from the ambient `ColorScheme` — the "Themed" preset.
class _ThemedPalette extends _PaletteConfig {
  const _ThemedPalette();

  @override
  bool operator ==(Object other) => other is _ThemedPalette;

  @override
  int get hashCode => (_ThemedPalette).hashCode;
}

/// One of the named terminal palettes, keyed by [name].
class _TerminalPalette extends _PaletteConfig {
  const _TerminalPalette(this.name);

  final String name;

  LowframerPalette get palette => _terminalPalettes[name]!;

  @override
  bool operator ==(Object other) =>
      other is _TerminalPalette && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// A fully custom palette, edited role by role.
class _CustomPalette extends _PaletteConfig {
  const _CustomPalette(this.palette);

  final LowframerPalette palette;

  @override
  bool operator ==(Object other) =>
      other is _CustomPalette && other.palette == palette;

  @override
  int get hashCode => palette.hashCode;
}

/// Where a palette comes from: derived, preset, or hand-built.
///
/// The presets are the point. "Themed" derives every role from the ambient
/// ColorScheme, so the art follows dark mode and the seed on its own; the
/// terminal palettes are a LowframerTheme override, held whatever the app
/// theme does; and the role knobs build an override by hand. Six arts render
/// at once so one change is visible across all of them, which no single
/// primitive shows.
class ThemingPage extends StatefulWidget {
  const ThemingPage({super.key});

  @override
  State<ThemingPage> createState() => _ThemingPageState();
}

class _ThemingPageState extends State<ThemingPage> {
  _PaletteConfig _config = const _ThemedPalette();

  /// The playground's presets: the theme-derived palette first, then each
  /// named terminal palette.
  static const _presets = <PlaygroundPreset<_PaletteConfig>>[
    PlaygroundPreset(
      label: 'Themed',
      config: _ThemedPalette(),
      summary: 'Derived from the app theme — follows dark mode and the seed.',
    ),
    PlaygroundPreset(
      label: 'Dracula',
      config: _TerminalPalette('Dracula'),
      summary: 'A terminal palette, held whatever the app theme does.',
    ),
    PlaygroundPreset(
      label: 'Solarized Dark',
      config: _TerminalPalette('Solarized Dark'),
      summary: 'A terminal palette, held whatever the app theme does.',
    ),
    PlaygroundPreset(
      label: 'Solarized Light',
      config: _TerminalPalette('Solarized Light'),
      summary: 'A terminal palette, held whatever the app theme does.',
    ),
    PlaygroundPreset(
      label: 'Monokai',
      config: _TerminalPalette('Monokai'),
      summary: 'A terminal palette, held whatever the app theme does.',
    ),
    PlaygroundPreset(
      label: 'Nord',
      config: _TerminalPalette('Nord'),
      summary: 'A terminal palette, held whatever the app theme does.',
    ),
  ];

  /// The six arts, rendered together so one palette change is visible across
  /// all of them at once.
  ///
  /// A plain Wrap rather than a ShowcaseEntryList: these are the previewed
  /// subject, not navigation. Laying them out with the widget the index uses
  /// for its own tabs gave them tappable-card affordances and made the page
  /// read as a level you could descend into, which it never was.
  /// A cover panel spans whatever width it is given, so each is bounded here;
  /// unbounded, a Wrap would give the first one the whole row.
  static const _arts = <Widget>[
    SizedBox(width: 220, child: LowframerCover(child: ButtonsArt())),
    SizedBox(width: 220, child: LowframerCover(child: TypographyArt())),
    SizedBox(width: 220, child: LowframerCover(child: ProfileFormArt())),
    SizedBox(width: 220, child: LowframerCover(child: DashboardArt())),
    SizedBox(width: 220, child: LowframerCover(child: ChatThreadArt())),
    SizedBox(width: 220, child: LowframerCover(child: SettingsListArt())),
  ];

  Widget _gallery() => const Wrap(
    spacing: 12,
    runSpacing: 12,
    alignment: WrapAlignment.center,
    children: _arts,
  );

  /// Edits one role of `base`, producing a custom palette configuration.
  ///
  /// `base` is the palette currently showing — whether that came from the
  /// theme, a terminal preset, or a prior custom edit — so a tweak always
  /// starts from what the eye sees rather than from scratch.
  /// Presents a grid of [choices] as a bottom sheet, returning the picked one.
  Future<Color?> _pickFromGrid(List<Color> choices, Color current) {
    return showModalBottomSheet<Color>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final color in choices)
                _ColorDot(
                  color: color,
                  selected: color == current,
                  onTap: () => Navigator.of(context).pop(color),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickColor(
    String role,
    Color current,
    LowframerPalette base,
  ) async {
    final picked = await _pickFromGrid(_pickerColors, current);
    if (picked == null || !mounted) return;
    final edited = switch (role) {
      'backdrop' => base.copyWith(backdrop: picked),
      'background' => base.copyWith(background: picked),
      'border' => base.copyWith(border: picked),
      'fill' => base.copyWith(fill: picked),
      'fillStrong' => base.copyWith(fillStrong: picked),
      _ => base.copyWith(accent: picked),
    };
    setState(() => _config = _CustomPalette(edited));
  }

  /// The palette the given configuration resolves to in the current context.
  ///
  /// A themed configuration derives from the ambient `ColorScheme`; the others
  /// carry their palette directly.
  LowframerPalette _resolve(BuildContext context, _PaletteConfig config) {
    return switch (config) {
      _ThemedPalette() => LowframerPalette.of(context),
      _TerminalPalette(:final palette) => palette,
      _CustomPalette(:final palette) => palette,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theming'),
        // A full-width hairline where the app bar meets the playground, so the
        // chrome reads as separate from the preview and inspector below it.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      body: SafeArea(
        child: Playground<_PaletteConfig>(
          config: _config,
          onChanged: (c) => setState(() => _config = c),
          presets: _presets,
          previewBuilder: (context, config) {
            final gallery = _gallery();
            // A themed configuration derives from the theme in place;
            // the others scope their palette over the arts.
            return switch (config) {
              _ThemedPalette() => gallery,
              _ => LowframerTheme(
                palette: _resolve(context, config),
                child: gallery,
              ),
            };
          },
          knobsBuilder: (context, config, onChanged) {
            // Edits start from what is currently showing, so tweaking a
            // preset carries its colors into the custom palette rather
            // than resetting to the theme's.
            final base = _resolve(context, config);
            return KnobGroup(
              title: 'Palette roles',
              children: [
                for (final (label, color) in <(String, Color)>[
                  ('backdrop', base.backdrop),
                  ('background', base.background),
                  ('border', base.border),
                  ('fill', base.fill),
                  ('fillStrong', base.fillStrong),
                  ('accent', base.accent),
                ])
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _RoleSwatch(
                      label: label,
                      color: color,
                      onTap: () => _pickColor(label, color, base),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// One selectable color, ringed when active.
class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}

/// One palette role: its name beside its current color, tap to change.
class _RoleSwatch extends StatelessWidget {
  const _RoleSwatch({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      // A full-width label makes the chip fill the inspector rather than
      // hugging its text, so the roles line up as a column of equal rows.
      label: SizedBox(
        width: double.infinity,
        child: Text(label),
      ),
      onPressed: onTap,
    );
  }
}
