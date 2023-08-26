import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:conditional_parent_widget/conditional_parent_widget.dart' show ConditionalParentWidget;


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
    // Real Racism Indicator:
    /*
    FutureBuilder(
                  future: racismDetection(_lastWords),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(
                          child: Text(
                            "Say something",
                            style: TextStyle(
                              fontSize: 36,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      case ConnectionState.waiting:
                        return const Center(
                          child: Text(
                            "Waiting for GPT response",
                            style: TextStyle(
                              fontSize: 36,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      case ConnectionState.active:
                        return const Center(
                          child: Text("This text should not display. WTH?"),
                        );
                      case ConnectionState.done:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                                width:
                                    40), // Sizedbox for the text to stay centered (balances with InfoPopupWidget) TO-DO: Check wether it is a good practice or not, find alternative to keep the text centered with the icon on the right
                            Text(
                              (_isItRacist ? "RACIST" : "NOT RACIST"),
                              style: const TextStyle(
                                fontSize: 36,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InfoPopupWidget(
                                contentTitle: _explanation,
                                child: const Icon(Icons.info),
                              ),
                            )
                          ],
                        );
                    } // switch statement
                  },
                ),
    */
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
      parentBuilder: (Widget child) =>
          AvatarGlow(endRadius: 60, child: child),
    );
  }
}
