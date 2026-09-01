import 'package:flutter/material.dart';
import 'package:lowframer_showcase/components/app_settings.dart';
import 'package:playgrounder/playgrounder.dart';

/// The shared chrome for every Library playground page.
///
/// Owns the back-navigating app bar and the hairline where the chrome meets
/// the playground, so each component page states only its own configuration
/// rather than repeating the scaffold. The equivalent of flutter_flowin's
/// ShowcaseScaffold, kept far smaller because this example has no design
/// system of its own to dress it with.
class PlaygroundPage<T> extends StatelessWidget {
  /// Creates a page previewing [T] beside its knobs.
  const PlaygroundPage({
    required this.title,
    required this.config,
    required this.onChanged,
    required this.previewBuilder,
    required this.knobsBuilder,
    this.presets = const [],
    this.previewMaxWidth,
    this.footer,
    super.key,
  });

  /// The page title, shown in the app bar.
  final String title;

  /// The configuration being previewed.
  final T config;

  /// Called when a preset or a knob changes the configuration.
  final ValueChanged<T> onChanged;

  /// Builds the subject for the current configuration.
  final Widget Function(BuildContext context, T config) previewBuilder;

  /// Builds the controls for the current configuration.
  final Widget Function(
    BuildContext context,
    T config,
    ValueChanged<T> onChanged,
  )
  knobsBuilder;

  /// Named starting configurations.
  final List<PlaygroundPreset<T>> presets;

  /// Clamps the previewed subject's width to what it really renders at.
  final double? previewMaxWidth;

  /// Content pinned to the bottom of the inspector, across both tabs.
  ///
  /// For controls that are not part of the configuration a preset describes —
  /// view options that should stay put while you page through presets.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const [AppSettingsActions()],
        // The playground runs edge to edge, so the bar needs its own rule to
        // separate itself from the preview rather than relying on padding.
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
        child: Playground<T>(
          config: config,
          onChanged: onChanged,
          presets: presets,
          previewMaxWidth: previewMaxWidth,
          footer: footer,
          previewBuilder: previewBuilder,
          knobsBuilder: knobsBuilder,
        ),
      ),
    );
  }
}
