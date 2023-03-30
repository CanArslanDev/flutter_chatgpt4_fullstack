import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../services/firebase_service.dart';
import 'base_controller.dart';

class MainPageController extends BaseController {
  RxList messageList = [].obs;
  String textFormSelectionValue = "";
  String chatGPTIcon = "";
  RxBool startingAnimation = false.obs;
  RxList<Map<String, dynamic>> textFieldMentionData = [
    {'id': 'image', 'display': 'image', 'full_name': '/Image', 'photo': ''},
    {
      'id': 'text',
      'display': 'text',
      'full_name': '/Text',
      'style': const TextStyle(color: Colors.purple),
      'photo': ''
    },
  ].obs;

  sendChatGPTMessage(String text) async {
    if (textFormSelectionValue == "text") {
      messageList.add({
        'messageText': await FirebaseService()
            .addChatGPTTextMessage(textFormSelectionValue, text),
        'messageSended': 'chatgpt_text'
      });
    } else {
      messageList.add({
        'messageText': await FirebaseService()
            .addChatGPTImageMessage(textFormSelectionValue, text),
        'messageSended': 'chatgpt_image'
      });
    }
  }

  mentionClear() {
    textFieldMentionData.clear();
  }

  mentionReset() {
    RxList<Map<String, dynamic>> temp = [
      {
        'id': 'image',
        'display': 'image',
        'full_name': '/Image',
        'photo': chatGPTIcon
      },
      {
        'id': 'text',
        'display': 'text',
        'full_name': '/Text',
        'style': const TextStyle(color: Colors.purple),
        'photo': chatGPTIcon
      },
    ].obs;
    textFieldMentionData.value = temp;
  }

  @override
  void onInit() async {
    super.onInit();
    // ignore: avoid_print
    print("Starting main page controller");
    chatGPTIcon = await FirebaseService().getChatGPTIcon();
    Timer(const Duration(milliseconds: 200),
        () => startingAnimation.value = true);
  }
}
