import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/components/app_settings.dart';

/// The two frames, shown together.
///
/// A reference page, not a playground. Neither widget takes a styling
/// argument — [LowframerWindow] is a fixed 160x120 canvas and [LowframerCover]
/// takes nothing but a child — so there is no configuration to step through.
/// What is worth seeing is the *relationship*: the cover is a full-width panel
/// that centres a window on it, which a toggle between the two would hide
/// rather than show.
///
/// When the window grows an orientation (see lowframer#18), that becomes a
/// real axis and this page earns presets.
class WindowPage extends StatelessWidget {
  /// Creates the window and cover reference.
  const WindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Window & cover'),
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
              constraints: const BoxConstraints(maxWidth: 640),
              child: const _Frames(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Frames extends StatelessWidget {
  const _Frames();

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
              'A fixed 160×120 canvas. Every composition draws inside one, '
              'so each carries the same optical weight.',
          // Aligned left rather than stretched: the window does not grow, and
          // centring it here would hide that.
          child: const Align(
            alignment: Alignment.centerLeft,
            child: DashboardArt(),
          ),
        ),
        labelled(
          name: 'Cover',
          note:
              'A full-width panel with a window centred on it, as it sits '
              'on a gallery card.',
          child: const LowframerCover(child: DashboardArt()),
        ),
      ],
    );
  }
}
