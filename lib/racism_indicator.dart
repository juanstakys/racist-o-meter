import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';

import 'widgets/racism_indicator_widgets.dart' show MicButton, Indicator;

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
    await _speechToText.listen(
        partialResults: false, onResult: _onSpeechResult);
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
          child: _lastWords == ''
              ? const Text(
                  "Press the button to speak",
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )
              : const Indicator(text: "null"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const MicButton()
    );
  }

  // On speech result
  void _onSpeechResult(SpeechRecognitionResult speechResult) async {
    _lastWords = speechResult.recognizedWords;
    // Call backend API to get whether the phrase was racist or not
    analysisResults = await racismDetection(_lastWords);
    setState(() {
      _isItRacist = analysisResults?["isItRacist"];
      _explanation = analysisResults?["explanation"];
    });
  }

  // API Call
  Future<Map> racismDetection(String statement) async {
    // TO-DO: Set server url from a variable
    // var url = Uri.http('192.168.0.13:8080', 'deteccion');
    // var response = await http.post(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    //   body: json.encode({'statement': statement}),
    // );
    // Map<String, dynamic> data = jsonDecode(response.body);
    // print(response.body);
    return Future.delayed(const Duration(seconds: 2), () {
      Map<String, dynamic> data = jsonDecode(
          '{"isItRacist": ${!_isItRacist}, "explanation": "HAHA, hello!"}');
      return data;
    });
  }
}
