import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';

void main() => runApp(const ExampleApp());

/// The smallest app that draws lowframer art.
///
/// One screen showing the four primitives the kit ships. Deliberately plain:
/// the point is what a composition is made of, not what can be built from it.
/// For that, see the showcase — every primitive as a playground, and the
/// compositions built from them.
class ExampleApp extends StatelessWidget {
  /// {@macro example_app}
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lowframer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    // Resolved from the ambient ColorScheme, so the art follows the app's
    // theme — dark mode included — with no extra code.
    final palette = LowframerPalette.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('lowframer')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The framed canvas every composition is drawn inside.
              LowframerWindow(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    // A box at stadium radius: the button silhouette.
                    LowframerBox.pill(color: palette.accent, width: 72),
                    // A text-placeholder line.
                    LowframerBox.line(color: palette.fillStrong, width: 96),
                    // Written text, as one continuous pen stroke.
                    LowframerScribble(color: palette.fill, width: 104),
                    // An outlined box: an empty field.
                    LowframerBox(
                      color: palette.background,
                      borderColor: palette.fillStrong,
                      height: 14,
                      radius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // The same window, centered on a cover panel, as it sits on a
              // gallery card.
              const SizedBox(
                width: 240,
                child: LowframerCover(child: _MiniArt()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A second composition, to show the cover panel framing one.
class _MiniArt extends StatelessWidget {
  const _MiniArt();

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 40),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.fill, width: 12),
              LowframerBox.line(color: palette.fill, width: 52),
              const Spacer(),
              LowframerBox.pill(color: palette.accent, width: 20, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
