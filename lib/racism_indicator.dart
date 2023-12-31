import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RacismIndicator extends StatefulWidget {
  const RacismIndicator({super.key});

  @override
  State<RacismIndicator> createState() => RacismIndicatorState();
}

class RacismIndicatorState extends State<RacismIndicator> {
  // Variables and functions
  Map? analysisResults;
  bool _isItRacist = false;
  String _explanation = "You are not racist until proven otherwise";

  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (_isItRacist
                ? [const Color(0xffdf1b0c), const Color(0xff6b0a2b)]
                : [const Color(0xff89ff8e), const Color(0xff45a7f5)]),
            stops: const [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FutureBuilder(
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
                        padding: EdgeInsets.all(8.0),
                        child: InfoPopupWidget(
                          contentTitle: _explanation,
                          child: Icon(Icons.info),
                        ),
                      )
                    ],
                  );
              } // switch statement
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _speechToText.isNotListening ? _startListening() : _stopListening();
        },
        shape: const CircleBorder(),
        tooltip: 'Press the button and speak',
        child: const Icon(Icons.mic),
      ),
    );
  }

  // On speech result
  void _onSpeechResult(SpeechRecognitionResult speechResult) async {
    if (speechResult.finalResult) {
      _lastWords = speechResult.recognizedWords;
      // Call backend API to get whether the phrase was racist or not
      analysisResults = await racismDetection(_lastWords);
      setState(() {
        _isItRacist = analysisResults?["isItRacist"];
        _explanation = analysisResults?["explanation"];
      });
    }
  }

  // API Call
  Future<Map> racismDetection(String statement) async {
    // TO-DO: Set server url from a variable
    var url = Uri.http('192.168.0.13:8080', 'deteccion');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'statement': statement}),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    print(response.body);
    return data;
  }
}
