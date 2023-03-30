import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  getChatGPTIcon() async {
    //Gets ChatGPT icon from firebase.
    var collection = FirebaseFirestore.instance.collection('chatgpt');
    var docSnapshot = await collection.doc('specifications').get();
    Map<String, dynamic>? data = docSnapshot.data();
    return data!['chatgptIcon'];
  }

  getChatGPTApiKey() async {
    //Gets ChatGPT api key from firebase.
    var collection = FirebaseFirestore.instance.collection('chatgpt');
    var docSnapshot = await collection.doc('specifications').get();
    Map<String, dynamic>? data = docSnapshot.data();
    return data!['chatgptApiKey'];
  }

  addChatGPTTextMessage(String selection, String contextMessage) async {
    //According to the situation selected from firebase (image or text), it acts with the chatgpt api and returns the text.
    String apiKey = await FirebaseService().getChatGPTApiKey();

    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt":
            contextMessage.toString().trim().replaceAll(RegExp(r' \s+'), ' '),
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );
    // Do something with the response
    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    String returnPrompt = await newresponse['choices'][0]['text'];
    return returnPrompt.trim().replaceAll(RegExp(r' \s+'), ' ');
  }

  addChatGPTImageMessage(String selection, String contextMessage) async {
    //According to the situation selected from firebase (image or text), it acts with the chatgpt api and returns the text.
    String apiKey = await FirebaseService().getChatGPTApiKey();

    final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode({
          'model': 'image-alpha-001',
          "prompt": contextMessage
              .toString()
              .trim()
              .replaceAll(RegExp(r' \s+'), ' ')
              .toString()
              .trim()
              .replaceAll(RegExp(r' \s+'), ' '),
          'num_images': 1,
          'size': '256x256'
        }));
    // Do something with the response
    var responseJson = jsonDecode(response.body);
    String returnPrompt = await responseJson['data'][0]['url'];
    return returnPrompt.trim().replaceAll(RegExp(r' \s+'), ' ');
  }
}
