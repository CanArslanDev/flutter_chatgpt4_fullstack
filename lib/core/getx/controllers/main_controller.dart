import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'base_controller.dart';

class MainPageController extends BaseController {
  RxList messageList = [].obs;
  String textFormSelectionValue = "";
  RxList<Map<String, dynamic>> textFieldMentionData = [
    {
      'id': 'image',
      'display': 'image',
      'full_name': '/Image',
      'photo':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
    {
      'id': 'text',
      'display': 'text',
      'full_name': '/Text',
      'style': TextStyle(color: Colors.purple),
      'photo':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
    },
  ].obs;
  mentionClear() {
    print("object");
    textFieldMentionData.clear();
  }

  mentionReset() {
    RxList<Map<String, dynamic>> temp = [
      {
        'id': 'image',
        'display': 'image',
        'full_name': '/Image',
        'photo':
            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
      },
      {
        'id': 'text',
        'display': 'text',
        'full_name': '/Text',
        'style': TextStyle(color: Colors.purple),
        'photo':
            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
      },
    ].obs;
    textFieldMentionData.value = temp;
  }

  @override
  void onInit() {
    super.onInit();
    // ignore: avoid_print
    print("Starting main page controller");
    // Timer(
    //   const Duration(seconds: 1),
    //   () {
    //     mainButtonsPrimary.value = 1;
    //   },
    // );
    // Timer(
    //   const Duration(seconds: 2),
    //   () {
    //     mainButtonsSecondary.value = 1;
    //   },
    // );
  }
}
