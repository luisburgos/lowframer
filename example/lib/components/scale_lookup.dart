import 'package:playgrounder/playgrounder.dart';

/// The step in [steps] whose value is [value], or the first step.
///
/// A [ScaleKnob] finds its slider position by equality on the whole
/// [ScaleStep], name included, so a step rebuilt from a config with a
/// differently formatted name matches nothing and the slider is handed an
/// index of -1. Resolving against the canonical list instead keeps the name
/// the list's to define, which is the only place it is written down.
ScaleStep stepFor(List<ScaleStep> steps, double value) {
  for (final step in steps) {
    if (step.value == value) return step;
  }
  return steps.first;
}
