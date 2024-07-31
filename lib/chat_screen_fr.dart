import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreenFr extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenFr> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, Icon> buttonIcons = {
    'Yes': Icon(Icons.check),
    'No': Icon(Icons.close),
    'Accident': Icon(Icons.warning),
    'Death':
        Icon(Icons.sentiment_very_dissatisfied), // fallback for the skull icon
    'Recovery': Icon(Icons.healing),
    'Illness': Icon(Icons.local_hospital),
    'Investigation': Icon(Icons.search),
    'Missing': Icon(Icons.person_outline),
    'Recall': Icon(Icons.replay),
  };
  final List<Map<String, dynamic>> _messages = [];
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _wordsSpoken = "";
  final FlutterTts flutterTts = FlutterTts();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    // Request microphone permission
    if (await Permission.microphone.request().isGranted) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() {
          _isListening = false;
        });
      } else {
        // Handle the case where the speech service is not available
        print('Speech service is not available');
      }
    } else {
      // Handle the case where permission is not granted
      print('Microphone permission is not granted');
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _speech.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
        });
      },
      listenFor: Duration(seconds: 20),
      pauseFor: Duration(seconds: 10),
      partialResults: true,
      onSoundLevelChange: (level) => print('Sound level: $level'),
      localeId: 'fr_FR',
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  void _stopListening() {
    _sendMessage(_wordsSpoken);
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  void dispose() {
    flutterTts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) async {
  if (message.trim().isEmpty) return;

  if (!mounted) return; // Ensure widget is still in the tree

  setState(() {
    _messages.add({'sender': 'user', 'message': message});
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
    _isLoading = true;
    _controller.clear();
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('http://172.17.0.22:5000/webhooks/rest/webhook'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'sender': 'user', 'message': message}),
    );

    if (response.statusCode == 200) {
      List responses = json.decode(response.body);
      for (var response in responses) {
        if (!mounted) return; // Ensure widget is still in the tree
        setState(() {
          _messages.add({
            'sender': 'bot',
            'message': response['text'],
            'buttons': response['buttons'] ?? []
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
          _speak(response['text']);
        });
      }
    } else {
      if (!mounted) return; // Ensure widget is still in the tree
      setState(() {
        _messages.add(
            {'sender': 'bot', 'message': 'Error: Could not send message.'});
      });
    }
  } catch (e) {
    if (!mounted) return; // Ensure widget is still in the tree
    setState(() {
      _messages.add(
          {'sender': 'bot', 'message': 'Error: Could not send message.'});
    });
  } finally {
    if (!mounted) return; // Ensure widget is still in the tree
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the back arrow
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset(
            'assets/images/small.png',
            width: 40,
            height: 40,
          ),
        ),
        title: Text(
          'AlphaBot',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold), // Adjust font size as needed
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.more_vert_rounded),
              color: Colors.blue,
              onPressed: () {
                _showMyDialog(context);
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white70, Colors.white10],
          ),
        ),
        child: Stack(
          children: [
            Scrollbar(
                controller: _scrollController, child: _buildMessagesList()),
            InputArea(
              controller: _controller,
              onSend: () => _sendMessage(_controller.text),
              onMicPressed:
                  _speech.isListening ? _stopListening : _startListening,
              isListening: _speech.isListening,
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Container(
      height: MediaQuery.of(context).size.height - 160,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
          shrinkWrap: false,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final message = _messages[index];
            // Check if message has buttons
            if (message.containsKey('buttons')) {
              return MessageWithButtons(
                message: message['message'],
                buttons: (message['buttons'] as List<dynamic>)
                    .cast<Map<String, dynamic>>(),
                onButtonPressed:
                    _sendMessage, // Function to handle button press
                isUser: message['sender'] == 'user',
                buttonIcons: buttonIcons,
              );
            } else {
              return MessageBubble(
                message: message['message'],
                isUser: message['sender'] == 'user',
              );
            }
          }),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  final TextEditingController _controller = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user can tap outside to dismiss
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width:
              MediaQuery.of(context).size.width * 0.8, // Set your desired width
          height: MediaQuery.of(context).size.height *
              0.8, // Set your desired height
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Give Feedback',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'How do you think about AlphaBot chat experience?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.sentiment_very_dissatisfied,
                            color: Colors.red, size: 35),
                        onPressed: () {},
                      ),
                      Text('Terrible'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.sentiment_dissatisfied,
                            color: Colors.orange, size: 35),
                        onPressed: () {},
                      ),
                      Text('Bad'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.sentiment_neutral,
                            color: Colors.amber, size: 35),
                        onPressed: () {},
                      ),
                      Text('Okay'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.sentiment_satisfied,
                            color: Colors.lightGreen, size: 35),
                        onPressed: () {},
                      ),
                      Text('Good'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.sentiment_very_satisfied,
                            color: Colors.green, size: 35),
                        onPressed: () {},
                      ),
                      Text('Amazed'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mention reasons for your rating',
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String feedbackText = _controller.text;
                      await _submitFeedback(feedbackText);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // foreground (text) color
                    ),
                    child: Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // text color
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _submitFeedback(String message) async {
  var url = Uri.parse('http://172.17.0.22:5282/Feedback/message/$message');

  try {
    var response = await http.post(url);

    if (response.statusCode == 200) {
      // Handle successful response
      print('Feedback message: ${response.body}');
    } else {
      // Handle errors
      print(
          'Failed to load feedback message, status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network errors
    print('Error fetching feedback message: $e');
  }
}

class InputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMicPressed;
  final bool isListening;

  InputArea({
    required this.controller,
    required this.onSend,
    required this.onMicPressed,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: MaterialButton(
                onPressed: onMicPressed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 50.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: Icon( isListening ? Icons.mic : Icons.mic_external_off,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.blue, width: 1.5),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        right: 50), // To make room for the send button
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Type a message to Robo",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      controller: controller,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        onPressed: onSend,
                        icon: Icon(Icons.send, color: Colors.white),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWithButtons extends StatelessWidget {
  final String message;
  final List<Map<String, dynamic>> buttons;
  final Function(String) onButtonPressed;
  final bool isUser;
  final Map<String, Icon> buttonIcons;

  const MessageWithButtons({
    Key? key,
    required this.message,
    required this.buttons,
    required this.onButtonPressed,
    required this.isUser,
    required this.buttonIcons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              Image.asset(
                'assets/images/small.png',
                width: 50,
                height: 50,
              ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: isUser
                          ? Color.fromRGBO(120, 64, 177, 1)
                          : Colors.white,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // spacing between buttons
                    runSpacing: 4.0, // spacing between lines
                    children: buttons.map<Widget>((button) {
                      return ElevatedButton.icon(
                          onPressed: () => onButtonPressed(button['title']),
                          icon: buttonIcons[button['title']] ??
                              Icon(Icons.help_outline),
                          label: Text(button['title']),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: isUser
                                ? Color(0xFF7D96E6)
                                : Color.fromRGBO(
                                    120, 64, 177, 1), // button text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ));
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) Image.asset('assets/images/small.png'),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: isUser
                    ? Color.fromRGBO(120, 64, 177, 1)
                    : Color.fromRGBO(246, 149, 149, 1),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ]),
    );
  }
}
