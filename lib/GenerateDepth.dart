import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT-3.5 Flutter Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _responseText = '';

  Future<void> _callGPT(String topicName) async {
    // Replace this with your OpenAI API key
    final String apiKey = 'Your Key';

    final String url = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> data = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': 'You are the smartest and the most insightful bot that can generate study material with accurate in-depth knowledge.',
        },
        {
          'role': 'user',
          'content': 'Generate in-depth paragraphs explaining the topic "$topicName". Include all topics, subtopics, and important parts without missing any details. Give examples, use cases, and scenarios to focus on depending on the topic. Also teach how to do it.',
        },
      ],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final reply = responseData['choices'][0]['message']['content'];
      setState(() {
        _responseText = reply;
      });
    } else {
      setState(() {
        _responseText = 'Error: Failed to fetch response from OpenAI API';
      });
    }
  } //Asynchronously updating responseText with SetState

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPT-3.5 Flutter Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final topicName = "SEO";
                if (topicName.isNotEmpty) {
                  await _callGPT(topicName);
                }
              },
              child: Text('Generate Explanation'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _responseText,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
