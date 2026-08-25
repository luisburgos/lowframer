import 'package:flutter/material.dart';

/// The one placeholder shape.
///
/// A rounded box covers every wireframe element — a line is a short flat box,
/// a pill is a box at stadium radius, a circle is a box at `size / 2` — so the
/// kit needs exactly one shape primitive instead of a Square/Circle/Line trio
/// that all wrap the same [Container].
class LowframerBox extends StatelessWidget {
  /// {@macro lowframer_box}
  const LowframerBox({
    required this.color,
    this.width = double.infinity,
    this.height = 4,
    this.radius = 2,
    this.borderColor,
    this.child,
    super.key,
  });

  /// A text-placeholder line: short, flat, quiet.
  const LowframerBox.line({
    required this.color,
    this.width = 32,
    this.height = 4,
    super.key,
  }) : radius = 2,
       borderColor = null,
       child = null;

  /// A pill — stadium-radius box, the button/chip silhouette.
  const LowframerBox.pill({
    required this.color,
    required this.width,
    this.height = 12,
    this.borderColor,
    this.child,
    super.key,
  }) : radius = 999;

  /// The fill color.
  final Color color;

  /// The box width. Defaults to filling the parent.
  final double width;

  /// The box height.
  final double height;

  /// The corner radius.
  final double radius;

  /// An optional hairline border, for outlined silhouettes.
  final Color? borderColor;

  /// Optional content, for boxes that frame smaller shapes (e.g. a sheet).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 0.75),
      ),
      child: child,
    );
  }
}
