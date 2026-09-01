import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowframer/lowframer.dart';
import 'package:lowframer_showcase/arts/arts.dart';
import 'package:lowframer_showcase/components/playground_page.dart';
import 'package:playgrounder/playgrounder.dart';

/// Which of the two frames the art is shown in.
enum WindowFrame {
  /// The bare window: the fixed miniature canvas art is drawn on.
  window,

  /// The window centered on a full-width cover panel, as it sits on a card.
  cover,
}

/// Which art fills the frame.
enum WindowSubject { buttons, dashboard, chatThread, settingsList }

/// The state of the [LowframerWindow] preview.
class WindowConfig extends Equatable {
  /// Creates a window configuration.
  const WindowConfig({
    this.frame = WindowFrame.window,
    this.subject = WindowSubject.dashboard,
  });

  /// Whether the art is framed bare or on a cover panel.
  final WindowFrame frame;

  /// The art inside the frame.
  final WindowSubject subject;

  /// A copy with the given fields replaced.
  WindowConfig copyWith({WindowFrame? frame, WindowSubject? subject}) =>
      WindowConfig(
        frame: frame ?? this.frame,
        subject: subject ?? this.subject,
      );

  @override
  List<Object?> get props => [frame, subject];
}

const _presets = <PlaygroundPreset<WindowConfig>>[
  PlaygroundPreset(
    label: 'Window',
    summary: 'The fixed miniature canvas every composition draws inside.',
    config: WindowConfig(),
  ),
  PlaygroundPreset(
    label: 'Cover',
    summary: 'The window centered on a panel, as it sits on a gallery card.',
    config: WindowConfig(frame: WindowFrame.cover),
  ),
];

/// A playground for [LowframerWindow] and [LowframerCover], the two frames.
///
/// Neither takes styling arguments — they are fixed by design, so that every
/// composition carries the same optical weight. The knobs therefore vary what
/// is framed rather than the frame, which is what there is to see.
class WindowPage extends StatefulWidget {
  /// Creates the window playground.
  const WindowPage({super.key});

  @override
  State<WindowPage> createState() => _WindowPageState();
}

class _WindowPageState extends State<WindowPage> {
  WindowConfig _config = const WindowConfig();

  Widget _art(WindowSubject subject) => switch (subject) {
    WindowSubject.buttons => const ButtonsArt(),
    WindowSubject.dashboard => const DashboardArt(),
    WindowSubject.chatThread => const ChatThreadArt(),
    WindowSubject.settingsList => const SettingsListArt(),
  };

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage<WindowConfig>(
      title: 'Window & cover',
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      // The cover spans its parent, so the stage is clamped to roughly a
      // card's width; left unbounded it would stretch across the pane and
      // stop reading as the panel it is.
      previewMaxWidth: 320,
      previewBuilder: (context, config) {
        final art = _art(config.subject);
        return switch (config.frame) {
          WindowFrame.window => art,
          WindowFrame.cover => LowframerCover(child: art),
        };
      },
      knobsBuilder: (context, config, onChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          DropdownKnob<WindowFrame>(
            label: 'Frame',
            value: config.frame,
            values: WindowFrame.values,
            labelOf: (f) => f.name,
            onChanged: (v) => onChanged(config.copyWith(frame: v)),
          ),
          DropdownKnob<WindowSubject>(
            label: 'Art',
            value: config.subject,
            values: WindowSubject.values,
            labelOf: (s) => s.name,
            onChanged: (v) => onChanged(config.copyWith(subject: v)),
          ),
        ],
      ),
    );
  }
}
