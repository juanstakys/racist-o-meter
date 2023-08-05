import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
// import 'dart:convert';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:http/http.dart' as http;

class RacistIndicator extends StatefulWidget {
  const RacistIndicator({super.key});

  @override
  State<RacistIndicator> createState() => RacistIndicatorState();
}

class RacistIndicatorState extends State<RacistIndicator> {

  // Variables and functions
  bool _isItRacist = false;


  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (_isItRacist ? [const Color(0xffdf1b0c), const Color(0xff6b0a2b)] : [const Color(0xff89ff8e), const Color(0xff45a7f5)]),
            stops: const [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 40), // Sizedbox for the text to stay centered (balances with InfoPopupWidget) TO-DO: Check wether it is a good practice or not, find alternative to keep the text centered with the icon on the right
              Text(
                (_isItRacist ? "RACIST" : "NOT RACIST"),
                style: const TextStyle(
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: InfoPopupWidget(
                  contentTitle: 'Info Popup Details',
                  child: Icon(Icons.info),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Testing
          setState(() {
            _isItRacist = !_isItRacist;
          });
        },
        shape: const CircleBorder(),
        tooltip: 'Press the button and speak',
        child: const Icon(Icons.mic),
      ),
    );
  }
}
