import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/utilities/configure.dart';

class ConsultAIScreen extends StatefulWidget {
  const ConsultAIScreen({super.key});

  @override
  _ConsultAIScreenState createState() => _ConsultAIScreenState();
}

class _ConsultAIScreenState extends State<ConsultAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'user': message});
        _isLoading = true;
      });
      _controller.clear();

      try {
        final response = await http.post(
          Uri.parse('$API_BASE_URL/ask_ai'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'question': message}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _messages.add({'ai': data['answer']});
            _isLoading = false;
          });
        } else {
          setState(() {
            _messages.add({'ai': 'Failed to get response from AI.'});
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _messages.add({'ai': 'Error occurred while connecting to AI.'});
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Consult AI', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message.containsKey('user');
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.grey[300] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.values.first,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                color: Colors.teal,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
