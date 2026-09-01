import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/components/app_settings.dart';

/// The six roles a composition paints with.
///
/// A reference page, not a playground. [LowframerPalette] is a data class with
/// no axis to vary: there is no configuration of it to step through, so
/// presets and knobs would be invented rather than earned. What the roles are
/// *for* is the thing worth writing down, and this is the only place it is.
///
/// Where a palette comes from — derived from the theme, overridden, or built
/// by hand — is the Theming example's subject, not this page's.
class PalettePage extends StatelessWidget {
  /// Creates the palette reference.
  const PalettePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palette'),
        actions: const [AppSettingsActions()],
        centerTitle: true,
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: const _Roles(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Roles extends StatelessWidget {
  const _Roles();

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    final theme = Theme.of(context);

    // Each role is shown as the primitive that actually uses it, rather than
    // as a bare colour chip: a page documenting the kit should be drawn with
    // the kit.
    final roles = <(String, String, Widget)>[
      (
        'backdrop',
        'The cover panel wash, one quiet step off the surface it sits on',
        LowframerBox(color: palette.backdrop, height: 28, radius: 6),
      ),
      (
        'background',
        "The window's canvas",
        LowframerBox(
          color: palette.background,
          borderColor: palette.border,
          height: 28,
          radius: 6,
        ),
      ),
      (
        'border',
        "The window's hairline frame",
        LowframerBox(
          color: palette.background,
          borderColor: palette.border,
          height: 28,
          radius: 6,
        ),
      ),
      (
        'fill',
        'The quiet placeholder, for everything that is not being emphasised',
        LowframerBox(color: palette.fill, height: 28, radius: 6),
      ),
      (
        'fillStrong',
        'A stronger fill, for elements that must read above fill',
        LowframerBox(color: palette.fillStrong, height: 28, radius: 6),
      ),
      (
        'accent',
        'The single emphasis colour, used sparingly',
        LowframerBox(color: palette.accent, height: 28, radius: 6),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        for (final (name, note, swatch) in roles)
          Row(
            spacing: 16,
            children: [
              SizedBox(width: 120, child: swatch),
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
        const SizedBox(height: 8),
        Text(
          'Every role is derived from the ambient ColorScheme unless a '
          'LowframerTheme overrides it. See the Theming example for where a '
          'palette comes from.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
