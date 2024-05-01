import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:untitled5/DetailedView.dart';

class HomePage extends StatelessWidget {
  // Sample map with titles and associated topics
  late final Map<String, List<String>> topicsMap;
  late final String topicContext;
  late String rsp = "Loading";

  Future<void> _callGPT(String topicName, String contextName) async {
    // Replace this with your OpenAI API key
    final String apiKey = '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';

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
      rsp = reply;
    }
    else {
      rsp = "Error retrieving response from API";
    }
  }

  HomePage({required this.topicsMap, required this.topicContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topicContext + ' ', style: TextStyle(color: Colors.white, fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.6),
        toolbarHeight: 80,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: topicsMap.length,
        itemBuilder: (context, index) {
          String title = topicsMap.keys.elementAt(index);
          List<String> topics = topicsMap[title]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8), // Add light padding between tiles
            child: Card(
              elevation: 4, // Add elevation to the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: ExpansionTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6)
                  ),
                ),
                children: topics.map((topic) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Add little space at the start
                    title: Text(topic, style: TextStyle(fontFamily: "Montserrat", color: Colors.black.withOpacity(0.6)),),
                    onTap: () async {
                      //callGPT
                      await _callGPT(topic, topicContext);
                      //Create a string
                      //Pass to next page

                      // Navigate to the TopicPage with the selected topic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedScreen(topicName: topic, contextName: topicContext, resp: rsp),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}