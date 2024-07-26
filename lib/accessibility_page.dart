import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class AccessibilityPage extends StatefulWidget {
  @override
  _AccessibilityPageState createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button and start speaking";
  double _confidence = 1.0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  List<String> _spokenTexts = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      // Request microphone permission
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission is required')),
        );
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          setState(() {
            _isListening = _speech.isListening;
          });
        },
        onError: (val) {
          print('onError: $val');
          setState(() {
            _isListening = _speech.isListening;
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _controller.forward();
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      } else {
        print("The user has denied the use of speech recognition.");
        setState(() => _isListening = false);
      }
    } else {
      setState(() {
        _isListening = false;
        _controller.reverse();
      });
      _speech.stop();
      if (_text.isNotEmpty) {
        setState(() {
          _spokenTexts.add(_text);
        });
      }
    }
  }

  void _onRecognizedTextTap(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recognized text tapped: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Semantics(
              label: 'Confidence level',
              child: SlideTransition(
                position: _offsetAnimation,
                child: Text(
                  'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            SizedBox(height: 20),
            Semantics(
              label: 'Recognized text',
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  _text,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            SizedBox(height: 20),
            Semantics(
              label: 'Voice command button',
              child: FloatingActionButton(
                onPressed: _listen,
                tooltip: 'Listen',
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
            SizedBox(height: 20),
            if (!_isListening && _text.isNotEmpty)
              Semantics(
                label: 'Recognized text clickable',
                child: GestureDetector(
                  onTap: () => _onRecognizedTextTap(_text),
                  child: Text(
                    'You said: $_text',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _spokenTexts.length,
                itemBuilder: (context, index) {
                  final spokenText = _spokenTexts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Semantics(
                      label: 'Spoken text: $spokenText',
                      child: GestureDetector(
                        onTap: () => _onRecognizedTextTap(spokenText),
                        child: Text(
                          spokenText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}