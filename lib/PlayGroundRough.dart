import 'dart:convert';

import 'package:http/http.dart' as http;

Map<String, List<String>> map = {
  "HTML" : ["Semantic HTML", "Forms", "Line Breaks", "Something"],
  "CSS" : ["Selectors", "id", "color", "some more"],
};

Future<void> callGPT(String topicName, String contextName) async {
  // Replace this with your OpenAI API key
  const String apiKey = 'Your Key';

  const String url = 'https://api.openai.com/v1/chat/completions';
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
        'content': 'Generate in-depth paragraphs explaining like I\'m 10 years old the topic "$topicName" in context of "$contextName". Include all topics, subtopics, and important parts without missing any details. Give examples, use cases, and scenarios to focus on depending on the topic. Also teach how to do it.',
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
  } else {
  }
}
