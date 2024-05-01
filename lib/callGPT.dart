import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:untitled5/CourseParsingAlgo.dart';
import 'package:untitled5/RoadmapScreen.dart';

class GPTScreen extends StatefulWidget {
  @override
  _GPTScreenState createState() => _GPTScreenState();
}

class _GPTScreenState extends State<GPTScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _response = '';
  late Map<String, List<String>> map;

  FutureOr<void> _callGPT(String message) async {
    final url = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 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',
    };
    final requestBody = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
          "You are the smartest and the most insightful course creation bot that can generate roadmaps with accurate in-depth knowledge",
        },
        {
          "role": "user",
          "content":
          "generate an in-depth roadmap for \"$message\" Include all topics, subtopics and important parts without missing on anything. Follow the format where Each Chapter name starts with '###', Each topic name starts with '-' and subtopics with '-', Dont write chapter number or Any Other extra information text, Start Directly with the name"
        }
      ]
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        _response = decodedResponse['choices'][0]['message']['content'];
        map = parseCourseContent(_response);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(topicsMap: map, topicContext: message,)));
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text('Create a new roadmap', style: TextStyle(fontFamily: "Montserrat",color: Colors.white, fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
        toolbarHeight: 100,
        elevation: 20,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: 'Enter Topic Name',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _callGPT(_textEditingController.text);
                },
                child: Text('Generate', style: TextStyle(fontFamily: "Montserrat"),),
              ),
              SizedBox(height: 20),
              InfoTile(),
              Spacer(),
              Image(image: AssetImage("assets/images/create.png"),)
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Welcome, Kanishk", style: TextStyle(fontFamily: "ArchivoBlack"),),
            subtitle: Text("\nBegin by entering the name of topic that you wish to create a course about",),
          ),
        ],
      ),
    );
  }
}

