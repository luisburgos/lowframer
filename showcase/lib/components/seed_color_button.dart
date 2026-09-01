import 'package:flutter/material.dart';

/// The diameter of one swatch.
const double _kSwatch = 32;

/// The gap between swatches, both between columns and between rows.
const double _kGap = 8;

/// The inset around the grid.
const double _kInset = 12;

/// How many swatches sit in a row.
const int _kColumns = 4;

/// Picks the app-level seed color from a menu of swatches.
///
/// The seed drives the whole `ColorScheme`, so it belongs beside the
/// light/dark toggle in the app bar rather than inside any one page: both are
/// app-level switches, and neither is about the page you happen to be on.
class SeedColorButton extends StatefulWidget {
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
  State<SeedColorButton> createState() => _SeedColorButtonState();
}

class _SeedColorButtonState extends State<SeedColorButton> {
  // Held so a swatch tap can close the menu; MenuController owns no
  // resources of its own, so there is nothing to dispose.
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    // Sized to its contents exactly: n columns carry n - 1 gaps, and any width
    // beyond that reads as an extra column that was started and left empty.
    const gridWidth = _kColumns * _kSwatch + (_kColumns - 1) * _kGap;

    return MenuAnchor(
      controller: _controller,
      // Dropped below the button rather than over it. A PopupMenuButton
      // anchors on top of its own icon, which hides the very control the
      // reader just pressed — and here that icon is a palette, the one glyph
      // a color menu should keep visible.
      alignmentOffset: const Offset(0, 8),
      style: const MenuStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(_kInset)),
      ),
      builder: (context, controller, child) => IconButton(
        tooltip: 'Seed color',
        icon: const Icon(Icons.palette_outlined),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        SizedBox(
          width: gridWidth,
          child: Wrap(
            spacing: _kGap,
            runSpacing: _kGap,
            children: [
              for (final color in widget.seeds)
                _Swatch(
                  color: color,
                  selected: color == widget.selected,
                  onTap: () {
                    widget.onChanged(color);
                    _controller.close();
                  },
                ),
            ],
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
        width: _kSwatch,
        height: _kSwatch,
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
