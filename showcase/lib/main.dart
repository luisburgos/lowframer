import 'package:flutter/material.dart';
import 'package:lowframer_showcase/catalogue.dart';
import 'package:lowframer_showcase/components/seed_color_button.dart';
import 'package:showcaser/showcaser.dart';

void main() => runApp(const ExampleApp());

/// Common seed colors for Flutter apps; the first is Material's default.
const seedColors = <Color>[
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

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _mode = ThemeMode.system;
  Color _seed = seedColors.first;

  void _toggleMode(BuildContext context) {
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
      home: HomePage(
        seed: _seed,
        onSeedChanged: (color) => setState(() => _seed = color),
        onToggleTheme: () => _toggleMode(context),
      ),
    );
  }
}

/// The widest the tab content may lay out.
///
/// Beyond this an ultrawide window only stretches the tiles, and a stretched
/// tile distorts its fixed-height cover art. The app bar stays full-width — it
/// is the content that caps, not the chrome.
const double _kContentMaxWidth = 1200;

/// The example index: the kit's primitives and the compositions built from
/// them, split across two tabs.
///
/// The split is the organising principle made visible. A primitive answers
/// "what can I draw with", a composition answers "what does it add up to", and
/// a reader is usually after one or the other.
class HomePage extends StatefulWidget {
  const HomePage({
    required this.seed,
    required this.onSeedChanged,
    required this.onToggleTheme,
    super.key,
  });

  /// The seed currently driving the scheme.
  final Color seed;

  /// Called with a newly picked seed.
  final ValueChanged<Color> onSeedChanged;

  /// Flips between light and dark.
  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('lowframer'),
        // Pinned rather than left to the platform default, which centers on
        // iOS and left-aligns elsewhere — so the title moved depending on the
        // viewport Flutter web inferred a platform from.
        centerTitle: true,
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Library'),
            Tab(text: 'Examples'),
          ],
        ),
        // Both switches are app-level — the seed drives the whole
        // ColorScheme, the toggle its brightness — so they sit together in the
        // chrome rather than inside any one page.
        actions: [
          SeedColorButton(
            seeds: seedColors,
            selected: widget.seed,
            onChanged: widget.onSeedChanged,
          ),
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
      // Centered under a max width so an ultrawide window widens the margins
      // instead of the cards.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kContentMaxWidth),
          child: TabBarView(
            controller: _tabs,
            children: [
              ShowcaseEntryList(entries: libraryEntries),
              ShowcaseEntryList(entries: exampleEntries),
            ],
          ),
        ),
      ),
    );
  }
}
