import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racist-o-meter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables para realizar las peticiones a la api con el paquete http

  var url = Uri.http('192.168.0.13:8080', 'deteccion');
  Future<http.Response> getRespuesta() async {
    var response = await http.get(url);
    return response;
  }

  // States y funciones necesarias del módulo speech_to_text

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      _lastWords = result.recognizedWords;
      print(_lastWords);
      var res = await getRespuesta();
      var data = json.decode(res.body);
      print(data["esRacista"]);
      setState(() {
      _esRacista = data["esRacista"];
    });
    }
  }

  // States y funciones propias de la app

  bool _esRacista = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              (_esRacista
                  ? "Lo que dijiste es racista >:("
                  : "Lo que dijiste NO es racista :)"),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Press button to speak',
        child: const Icon(Icons.mic),
      ),
    );
  }
}

// Clase respuestaGPT

class RespuestaGPT {
  bool esRacista;
  String explicacion;

  RespuestaGPT({required this.esRacista, required this.explicacion});

  factory RespuestaGPT.fromJson(Map<String, dynamic> json) {
    return RespuestaGPT(
      esRacista: json['esRacista'],
      explicacion: json["explicacion"],
    );
  }
}
