import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:playgrounder/playgrounder.dart';
import 'package:showcaser/showcaser.dart';

void main() => runApp(const ExampleApp());

/// Common seed colors for Flutter apps; the first is Material's default.
const _seedColors = <Color>[
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lime,
  Colors.amber,
  Colors.orange,
  Colors.red,
  Colors.pink,
  Colors.brown,
];

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

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _mode = ThemeMode.system;
  Color _seed = _seedColors.first;

  void _toggleMode() {
    setState(() {
      // Resolve "system" to what is currently showing, then flip it.
      final brightness = MediaQuery.platformBrightnessOf(context);
      final isDark = switch (_mode) {
        ThemeMode.system => brightness == Brightness.dark,
        ThemeMode.dark => true,
        ThemeMode.light => false,
      };
      _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lowframer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _mode,
      home: GalleryPage(
        seed: _seed,
        onSeedChanged: (color) => setState(() => _seed = color),
        onToggleTheme: _toggleMode,
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    required this.seed,
    required this.onSeedChanged,
    required this.onToggleTheme,
    super.key,
  });

  final Color seed;
  final ValueChanged<Color> onSeedChanged;
  final VoidCallback onToggleTheme;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
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

  /// The same six arts render for every palette; only the source changes.
  ///
  /// Each is a showcaser entry: the art is passed already wrapped in a
  /// [LowframerCover], because showcaser draws cover art as given rather than
  /// supplying a panel of its own.
  static final _entries = <ShowcaseEntry>[
    for (final (title, subtitle, art) in <(String, String, Widget)>[
      ('Buttons', 'Pill silhouettes, one accent', const ButtonsArt()),
      ('Typography', 'Scribbles of falling weight', const TypographyArt()),
      (
        'Profile form',
        'Avatar, labeled fields, submit',
        const ProfileFormArt(),
      ),
      ('Dashboard', 'Top bar, stat tiles, bars', const DashboardArt()),
      (
        'Chat thread',
        'Alternating bubbles, compose bar',
        const ChatThreadArt(),
      ),
      ('Settings list', 'Icon rows with toggles', const SettingsListArt()),
    ])
      ShowcaseEntry(
        title: title,
        subtitle: subtitle,
        coverArt: (_) => LowframerCover(child: art),
        builder: (_) => _ArtPage(title: title, art: art),
      ),
  ];

  /// The gallery, laid out by showcaser.
  ///
  /// Replaces a hand-rolled GridView with hardcoded breakpoints: the shared
  /// list measures the width it is actually given and lets each row size to
  /// its own tallest tile, which a fixed-extent grid cannot do.
  Widget _gallery() => ShowcaseEntryList(
    entries: _entries,
    padding: EdgeInsets.zero,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('lowframer'),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onToggleTheme,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Playground<_PaletteConfig>(
          config: _config,
          onChanged: (c) => setState(() => _config = c),
          presets: _presets,
          // The app-level seed lives in the inspector's pinned footer, a
          // control that persists across the Presets and Custom tabs. The
          // swatches are shown inline so a color is one tap away.
          footer: _SeedPicker(
            seeds: _seedColors,
            selected: widget.seed,
            onChanged: widget.onSeedChanged,
          ),
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

/// Where a tapped gallery entry lands: the art alone, at rest.
///
/// The gallery routes to a page per entry, so the example shows what that
/// looks like rather than leaving the tiles inert.
class _ArtPage extends StatelessWidget {
  const _ArtPage({required this.title, required this.art});

  final String title;
  final Widget art;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: art),
    );
  }
}

/// The app-level seed picker, shown in the inspector's pinned footer.
///
/// A label naming the control over a wrap of the seed swatches, so a color is
/// one tap away rather than behind a sheet. It sits in the playground's footer,
/// which persists across the Presets and Custom tabs.
class _SeedPicker extends StatelessWidget {
  const _SeedPicker({
    required this.seeds,
    required this.selected,
    required this.onChanged,
  });

  final List<Color> seeds;
  final Color selected;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SEED COLOR',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in seeds)
              _ColorDot(
                color: color,
                selected: color == selected,
                onTap: () => onChanged(color),
              ),
          ],
        ),
      ],
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

/// A miniature "buttons" illustration: pill silhouettes, one accent.
class ButtonsArt extends StatelessWidget {
  const ButtonsArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.pill(color: palette.accent, width: 72, height: 16),
          LowframerBox.pill(color: palette.fill, width: 96, height: 16),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 56,
            height: 16,
          ),
        ],
      ),
    );
  }
}

/// A miniature "typography" illustration: scribbles of falling weight.
class TypographyArt extends StatelessWidget {
  const TypographyArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          LowframerScribble(
            color: palette.accent,
            width: 76,
            height: 11,
            strokeWidth: 3,
            wavelength: 16,
            seed: 1,
          ),
          LowframerScribble(
            color: palette.fillStrong,
            width: 100,
            wavelength: 11,
            seed: 2,
          ),
          LowframerScribble(
            color: palette.fill,
            width: 118,
            height: 5,
            strokeWidth: 1.5,
            wavelength: 7,
            seed: 3,
          ),
        ],
      ),
    );
  }
}

/// A miniature profile form: avatar, labeled fields, accent submit.
class ProfileFormArt extends StatelessWidget {
  const ProfileFormArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(
                color: palette.fillStrong,
                width: 18,
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 44),
                  LowframerBox.line(color: palette.fill, width: 30),
                ],
              ),
            ],
          ),
          const Spacer(),
          LowframerBox.line(color: palette.fillStrong, width: 28),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const SizedBox(height: 5),
          LowframerBox.line(color: palette.fillStrong, width: 36),
          const SizedBox(height: 3),
          LowframerBox(color: palette.fill, height: 12, radius: 4),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox.pill(color: palette.accent, width: 44),
          ),
        ],
      ),
    );
  }
}

/// A miniature dashboard: top bar, stat tiles, bars, list lines.
class DashboardArt extends StatelessWidget {
  const DashboardArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LowframerBox.line(color: palette.fillStrong, width: 34),
              const Spacer(),
              LowframerBox.pill(color: palette.fill, width: 10, height: 10),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            spacing: 6,
            children: [
              Expanded(
                child: LowframerBox(
                  color: palette.fill,
                  height: 18,
                  radius: 4,
                ),
              ),
              Expanded(
                child: LowframerBox(
                  color: palette.fill,
                  height: 18,
                  radius: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              LowframerBox(color: palette.fill, width: 14, height: 12),
              LowframerBox(color: palette.fill, width: 14, height: 20),
              LowframerBox(color: palette.accent, width: 14, height: 26),
              LowframerBox(color: palette.fill, width: 14, height: 16),
            ],
          ),
          const Spacer(),
          LowframerBox.line(color: palette.fill, width: 96),
          const SizedBox(height: 3),
          LowframerBox.line(color: palette.fill, width: 76),
        ],
      ),
    );
  }
}

/// A miniature chat thread: alternating bubbles and a compose bar.
class ChatThreadArt extends StatelessWidget {
  const ChatThreadArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: LowframerBox(color: palette.fill, width: 62, height: 12),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox(color: palette.accent, width: 48, height: 12),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: LowframerBox(color: palette.fill, width: 74, height: 12),
          ),
          const Spacer(),
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: LowframerBox(
                  color: palette.background,
                  borderColor: palette.fillStrong,
                  height: 14,
                  radius: 7,
                ),
              ),
              LowframerBox.pill(color: palette.accent, width: 14, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

/// A miniature settings list: icon rows with toggles, one active.
class SettingsListArt extends StatelessWidget {
  const SettingsListArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget row({required bool active}) => Row(
      spacing: 6,
      children: [
        LowframerBox.pill(color: palette.fill, width: 12),
        LowframerBox.line(
          color: active ? palette.fillStrong : palette.fill,
          width: 52,
        ),
        const Spacer(),
        LowframerBox.pill(
          color: active ? palette.accent : palette.fill,
          width: 20,
          height: 10,
        ),
      ],
    );

    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 40),
          row(active: true),
          row(active: false),
          row(active: false),
        ],
      ),
    );
  }
}
