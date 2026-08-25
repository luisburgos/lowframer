import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';

void main() => runApp(const ExampleApp());

/// Common seed colors for Flutter apps; the first is Material's default.
const _seedColors = <Color>[
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.orange,
  Colors.pink,
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

/// Where the gallery's palette comes from.
enum _PaletteMode { theme, presets, custom }

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
  _PaletteMode _paletteMode = _PaletteMode.theme;
  String _terminal = _terminalPalettes.keys.first;
  LowframerPalette? _custom;

  /// The same six arts render in every mode; only the palette source changes.
  static const _arts = <Widget>[
    LowframerCover(child: ButtonsArt()),
    LowframerCover(child: TypographyArt()),
    LowframerCover(child: ProfileFormArt()),
    LowframerCover(child: DashboardArt()),
    LowframerCover(child: ChatThreadArt()),
    LowframerCover(child: SettingsListArt()),
  ];

  /// A responsive grid: 4, 3, 2 or 1 columns depending on the width the
  /// gallery is actually given.
  Widget _gallery() => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = switch (width) {
        >= 1100 => 4,
        >= 800 => 3,
        >= 520 => 2,
        _ => 1,
      };
      return GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 150,
        ),
        children: _arts,
      );
    },
  );

  Future<void> _pickColor(String role, Color current) async {
    final picked = await showModalBottomSheet<Color>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final color in _pickerColors)
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
    if (picked == null || !mounted) return;
    setState(() {
      _custom = switch (role) {
        'backdrop' => _custom!.copyWith(backdrop: picked),
        'background' => _custom!.copyWith(background: picked),
        'border' => _custom!.copyWith(border: picked),
        'fill' => _custom!.copyWith(fill: picked),
        'fillStrong' => _custom!.copyWith(fillStrong: picked),
        _ => _custom!.copyWith(accent: picked),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Custom starts from what the theme currently derives, so the user
    // tweaks a sensible palette instead of building one from scratch.
    final custom = _custom ??= LowframerPalette.of(context);

    // App-level: the seed recolors the whole app — Material chrome, the
    // Theme mode's derived arts, and the palette Custom starts from — so it
    // sits above the mode switch rather than inside any one segment.
    final seedPicker = Wrap(
      spacing: 8,
      children: [
        for (final color in _seedColors)
          _ColorDot(
            color: color,
            selected: color == widget.seed,
            onTap: () => widget.onSeedChanged(color),
          ),
      ],
    );

    final controls = switch (_paletteMode) {
      _PaletteMode.theme => const SizedBox.shrink(),
      _PaletteMode.presets => Wrap(
        spacing: 8,
        children: [
          for (final name in _terminalPalettes.keys)
            ChoiceChip(
              label: Text(name),
              selected: name == _terminal,
              onSelected: (_) => setState(() => _terminal = name),
            ),
        ],
      ),
      _PaletteMode.custom => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _RoleSwatch(
            label: 'backdrop',
            color: custom.backdrop,
            onTap: () => _pickColor('backdrop', custom.backdrop),
          ),
          _RoleSwatch(
            label: 'background',
            color: custom.background,
            onTap: () => _pickColor('background', custom.background),
          ),
          _RoleSwatch(
            label: 'border',
            color: custom.border,
            onTap: () => _pickColor('border', custom.border),
          ),
          _RoleSwatch(
            label: 'fill',
            color: custom.fill,
            onTap: () => _pickColor('fill', custom.fill),
          ),
          _RoleSwatch(
            label: 'fillStrong',
            color: custom.fillStrong,
            onTap: () => _pickColor('fillStrong', custom.fillStrong),
          ),
          _RoleSwatch(
            label: 'accent',
            color: custom.accent,
            onTap: () => _pickColor('accent', custom.accent),
          ),
        ],
      ),
    };

    // Theme mode derives; the other two scope an override over the gallery.
    final gallery = switch (_paletteMode) {
      _PaletteMode.theme => _gallery(),
      _PaletteMode.presets => LowframerTheme(
        palette: _terminalPalettes[_terminal]!,
        child: _gallery(),
      ),
      _PaletteMode.custom => LowframerTheme(
        palette: custom,
        child: _gallery(),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('lowframer'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          seedPicker,
          const SizedBox(height: 12),
          Center(
            child: SegmentedButton<_PaletteMode>(
              segments: const [
                ButtonSegment(value: _PaletteMode.theme, label: Text('Theme')),
                ButtonSegment(
                  value: _PaletteMode.presets,
                  label: Text('Presets'),
                ),
                ButtonSegment(
                  value: _PaletteMode.custom,
                  label: Text('Custom'),
                ),
              ],
              selected: {_paletteMode},
              onSelectionChanged: (selection) =>
                  setState(() => _paletteMode = selection.first),
            ),
          ),
          const SizedBox(height: 12),
          controls,
          const SizedBox(height: 12),
          gallery,
        ],
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
      label: Text(label),
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
