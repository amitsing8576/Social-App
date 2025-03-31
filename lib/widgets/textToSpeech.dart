import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSPage extends StatefulWidget {
  final String text;
  final Function(bool)? onPlayStateChanged;

  TTSPage({required this.text, this.onPlayStateChanged});

  @override
  _TTSPageState createState() => _TTSPageState();
}

class _TTSPageState extends State<TTSPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _setupCompletionListener();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  void _setupCompletionListener() {
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
      if (widget.onPlayStateChanged != null) {
        widget.onPlayStateChanged!(false);
      }
    });
  }

  Future<void> _speak() async {
    if (widget.text.isNotEmpty) {
      await flutterTts.speak(widget.text);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isPlaying = !isPlaying;
        });
        if (widget.onPlayStateChanged != null) {
          widget.onPlayStateChanged!(isPlaying);
        }
        isPlaying ? _speak() : _stop();
      },
      icon: Icon(isPlaying
          ? Icons.pause_circle_outline
          : Icons.play_circle_outline_sharp),
    );
  }
}
