import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailedScreen extends StatefulWidget {
  const DetailedScreen({super.key, required this.topicName, required this.contextName, required this.resp});
  final String topicName;
  final String contextName;
  final String resp;

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}


class _DetailedScreenState extends State<DetailedScreen> {

  String _responseText = '';

  Future<void> _callGPT(String topicName, String contextName) async {
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
          'content': 'Generate in-depth paragraphs explaining like I\'m 10 years old on the topic "$topicName" in context of "$contextName". Include all topics, subtopics, and important parts without missing any details. Give examples, use cases, and scenarios to focus on depending on the topic. Also teach how to do it.',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName, style: TextStyle(color: Colors.white, fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 150),
          child: Text(
          widget.resp,
            //Call GPT for indepth Explaination
            style: const TextStyle(fontSize: 16,
            fontFamily: "Montserrat"),
          ),
        ),
      ),
    );;
  }
}

