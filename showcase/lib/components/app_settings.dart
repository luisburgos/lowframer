import 'package:flutter/material.dart';
import 'package:lowframer_showcase/components/seed_color_button.dart';

/// The app-level switches, scoped above the navigator.
///
/// The seed and the brightness belong to the app, not to any one page, so
/// every page's chrome should offer them — including pushed routes. Scoping
/// them here rather than threading callbacks through each page keeps a new
/// page from having to know they exist: it just puts [AppSettingsActions] in
/// its app bar.
class AppSettings extends InheritedWidget {
  /// Scopes the app-level switches over [child].
  const AppSettings({
    required this.seed,
    required this.seeds,
    required this.onSeedChanged,
    required this.onToggleBrightness,
    required super.child,
    super.key,
  });

  /// The seed currently driving the scheme.
  final Color seed;

  /// The seeds on offer.
  final List<Color> seeds;

  /// Called with a newly picked seed.
  final ValueChanged<Color> onSeedChanged;

  /// Flips between light and dark.
  final VoidCallback onToggleBrightness;

  /// The ambient settings. Throws when absent, which is a wiring bug.
  static AppSettings of(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<AppSettings>();
    assert(settings != null, 'No AppSettings in scope');
    return settings!;
  }

  @override
  bool updateShouldNotify(AppSettings oldWidget) =>
      seed != oldWidget.seed ||
      seeds != oldWidget.seeds ||
      onSeedChanged != oldWidget.onSeedChanged ||
      onToggleBrightness != oldWidget.onToggleBrightness;
}

/// The seed picker and brightness toggle, for an [AppBar]'s actions.
///
/// Every page in the showcase puts these in its chrome, so a reader can
/// recolour the art without navigating back to the index first.
class AppSettingsActions extends StatelessWidget {
  /// Creates the shared app-bar actions.
  const AppSettingsActions({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeedColorButton(
          seeds: settings.seeds,
          selected: settings.seed,
          onChanged: settings.onSeedChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: settings.onToggleBrightness,
          ),
        ),
      ],
    );
  }
}
