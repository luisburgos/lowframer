import 'package:flutter/material.dart';

/// Picks the app-level seed color from a popup menu.
///
/// The seed drives the whole `ColorScheme`, so it belongs beside the
/// light/dark toggle in the app bar rather than inside any one page: both are
/// app-level switches, and neither is about the page you happen to be on.
class SeedColorButton extends StatelessWidget {
  /// Creates a seed picker over [seeds].
  const SeedColorButton({
    required this.seeds,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// The colors offered.
  final List<Color> seeds;

  /// The seed currently driving the scheme.
  final Color selected;

  /// Called with the picked seed.
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Color>(
      tooltip: 'Seed color',
      icon: const Icon(Icons.palette_outlined),
      onSelected: onChanged,
      // A grid rather than a list: a column of twelve colors would run off the
      // screen, and a swatch needs no label to be understood.
      itemBuilder: (context) => [
        PopupMenuItem<Color>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 168,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final color in seeds)
                    _Swatch(
                      color: color,
                      selected: color == selected,
                      // Pops with the picked value rather than calling
                      // onChanged directly, so the menu closes on tap the way
                      // a normal menu item would.
                      onTap: () => Navigator.of(context).pop(color),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One selectable seed, ringed when active.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
            color: selected ? scheme.onSurface : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
