import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'conditional_parent_widget.dart';

class Indicator extends StatefulWidget {

  const Indicator({super.key, required text});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  final String text = '';

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 36,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class MicButton extends StatefulWidget {

  const MicButton({super.key});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: _isListening,
      child: Container(
        margin: _isListening ? const EdgeInsets.all(0) : const EdgeInsets.all(32), // margin is proportional to endRadius of AvatarGlow
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isListening = !_isListening;
            });
          },
          shape: const CircleBorder(),
          tooltip: 'Press the button to speak',
          child: const Icon(Icons.mic),
        ),
      ),
      conditionalBuilder: (Widget child) =>
          AvatarGlow(endRadius: 60, child: child),
    );
  }
}
