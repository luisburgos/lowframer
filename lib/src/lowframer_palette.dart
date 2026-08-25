import 'package:flutter/material.dart';

/// The colors a lowframer composition paints with.
///
/// [LowframerPalette.of] resolves the palette compositions should use: an
/// ambient [LowframerTheme] override when one is in scope, otherwise a
/// palette derived from the ambient [ColorScheme] — which is what makes the
/// art follow the app's theme, dark mode included, with no extra code.
///
/// To customize, either construct a palette directly, or start from the
/// derived one and [copyWith] the roles to change.
@immutable
class LowframerPalette {
  /// Creates a palette from explicit colors.
  const LowframerPalette({
    required this.backdrop,
    required this.background,
    required this.border,
    required this.fill,
    required this.fillStrong,
    required this.accent,
  });

  /// Resolves the ambient palette: a [LowframerTheme] override when present,
  /// otherwise derived from [context]'s [ColorScheme].
  factory LowframerPalette.of(BuildContext context) {
    final override = LowframerTheme.maybeOf(context);
    if (override != null) return override;

    final scheme = Theme.of(context).colorScheme;
    return LowframerPalette(
      backdrop: scheme.onSurface.withValues(alpha: 0.05),
      background: scheme.surface,
      border: scheme.outlineVariant,
      // Alpha over onSurface rather than the container roles: on many schemes
      // surfaceContainerHighest sits within a hair of surface, which makes
      // the quiet shapes invisible at art scale.
      fill: scheme.onSurface.withValues(alpha: 0.14),
      fillStrong: scheme.onSurface.withValues(alpha: 0.35),
      accent: scheme.primary,
    );
  }

  /// The cover panel's wash, one quiet step off the surface it sits on.
  final Color backdrop;

  /// The window's canvas color.
  final Color background;

  /// The window's hairline frame color.
  final Color border;

  /// The quiet placeholder fill.
  final Color fill;

  /// A stronger fill for elements that must read above [fill].
  final Color fillStrong;

  /// The single emphasis color, used sparingly.
  final Color accent;

  /// A copy of this palette with the given roles replaced.
  LowframerPalette copyWith({
    Color? backdrop,
    Color? background,
    Color? border,
    Color? fill,
    Color? fillStrong,
    Color? accent,
  }) {
    return LowframerPalette(
      backdrop: backdrop ?? this.backdrop,
      background: background ?? this.background,
      border: border ?? this.border,
      fill: fill ?? this.fill,
      fillStrong: fillStrong ?? this.fillStrong,
      accent: accent ?? this.accent,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LowframerPalette &&
      other.backdrop == backdrop &&
      other.background == background &&
      other.border == border &&
      other.fill == fill &&
      other.fillStrong == fillStrong &&
      other.accent == accent;

  @override
  int get hashCode =>
      Object.hash(backdrop, background, border, fill, fillStrong, accent);
}

/// Scopes a custom [LowframerPalette] over a subtree.
///
/// Every composition below that resolves its colors through
/// [LowframerPalette.of] — including the framed window and cover panel —
/// picks up [palette] instead of the [ColorScheme]-derived default.
class LowframerTheme extends InheritedWidget {
  /// {@macro lowframer_theme}
  const LowframerTheme({
    required this.palette,
    required super.child,
    super.key,
  });

  /// The palette to use below this widget.
  final LowframerPalette palette;

  /// The nearest ancestor override, or null when none is in scope.
  static LowframerPalette? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LowframerTheme>()?.palette;

  @override
  bool updateShouldNotify(LowframerTheme oldWidget) =>
      palette != oldWidget.palette;
}
