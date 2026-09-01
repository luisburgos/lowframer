# lowframer

**The low-fidelity wireframe art kit for Flutter.**

Catalogues and galleries need a cover per item, and the usual options all trade
off: screenshots go stale and lock to one theme, icons are too abstract, and
illustrations need a designer and can't follow dark mode.

**lowframer's art is code instead:** a miniature wireframe composed from a few
primitives, drawn to say exactly what each item is, **current and on-theme by
construction.**

### 🔎 [**Try the live demo →**](https://luisburgos.github.io/lowframer/)

The showcase, running in your browser: every primitive as a playground, and the compositions built from them. No install required.

## Features ✨

- **Compose exactly the art you need:** Window, Cover, Box (line/pill),
  Scribble, Palette; five primitives, a distinct cover art in ~20 lines, no
  designer in the loop
- **Theme-aware for free:** every color derives from the ambient
  `ColorScheme`; light/dark needs zero per-theme code
- **Handwriting without words:** the Scribble draws deterministic pen
  strokes with size, frequency, seed, and italic knobs
- **Deterministic by contract:** no `Random`; identical input paints
  identical pixels, golden- and test-stable
- **Zero assets, zero dependencies:** pure Flutter, nothing to bundle

## Installation 💻

```sh
flutter pub add lowframer
```

Or add it to your `pubspec.yaml`:

```yaml
dependencies:
  lowframer: ^0.3.0
```

## Usage 🚀

A miniature "buttons" illustration, a framed window holding pill
silhouettes with one accent:

```dart
import 'package:lowframer/lowframer.dart';

class ButtonsArt extends StatelessWidget {
  const ButtonsArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.pill(color: palette.accent, width: 72, height: 16),
          LowframerBox.pill(color: palette.fill, width: 96, height: 16),
          LowframerScribble(color: palette.fillStrong, width: 90),
        ],
      ),
    );
  }
}
```

Wrap the window in a `LowframerCover` to present it as a card cover: a
full-width wash panel with the framed art centered and lifted off it.

### The scribble's knobs

`LowframerScribble` stands in for *written* text: one continuous wavy pen
stroke, no actual words.

| Knob | Meaning |
|---|---|
| `color` | The ink color |
| `width` / `height` | Line length and wave band; with `strokeWidth`, the writing's size |
| `strokeWidth` | Pen thickness |
| `wavelength` | Pixels per peak-and-valley cycle, the writing's frequency |
| `seed` | Varies the handwriting; two lines with the same knobs read as different sentences |
| `fontStyle` | Mirrors `TextStyle.fontStyle`; italic slants the stroke |
| `style` | `sketch` (uniform drawn wave, default) or `wave` (irregular scrawl) |

### Customizing the palette

`LowframerPalette.of(context)` derives from the ambient `ColorScheme` by
default, so the art follows your theme, dark mode included, with no extra
code. To customize, scope a palette over a subtree with `LowframerTheme`;
everything below it (including `LowframerWindow` and `LowframerCover`, which
resolve internally) picks it up:

```dart
LowframerTheme(
  palette: LowframerPalette(
    backdrop: Color(0x14704214),
    background: Color(0xFFFDF6EC),
    border: Color(0xFFE3D5C0),
    fill: Color(0x3D704214),
    fillStrong: Color(0x8A704214),
    accent: Color(0xFF9C4221),
  ),
  child: LowframerCover(child: ButtonsArt()),
)
```

To tweak rather than replace, start from the derived palette and `copyWith`:

```dart
final palette = LowframerPalette.of(context).copyWith(accent: Colors.teal);
```

Two apps live in this repository, and they answer different questions.

[`example/`](example) is the smallest app that draws lowframer art — one
screen, the four primitives, ~120 lines. Start there to see what a composition
is made of:

```sh
cd example && fvm flutter run
```

[`showcase/`](showcase) is the full thing: a playground per primitive, where
you turn its knobs and watch the art redraw, plus the compositions built from
them. It is what the live demo serves:

```sh
cd showcase && fvm flutter run
```
