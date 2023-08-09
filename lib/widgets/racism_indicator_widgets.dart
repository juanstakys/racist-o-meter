import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Indicator extends StatelessWidget {
  final String text = '';

  const Indicator({super.key, required text});

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

class MicButton extends StatelessWidget {
  bool isListening = true;

  MicButton({super.key, required this.isListening});

  @override
  Widget build(BuildContext context) {
    return isListening
        ? AvatarGlow(
            endRadius: 40.0,
            child: FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              tooltip: 'Press the button to speak',
              child: const Icon(Icons.mic),
            ),
          )
        : FloatingActionButton(
            onPressed: () {},
            shape: const CircleBorder(),
            tooltip: 'Press the button to speak',
            child: const Icon(Icons.mic),
          );
  }
}
