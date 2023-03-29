import 'package:flutter_chatgpt4_fullstack/core/getx/controllers/main_controller.dart';
import 'package:get/get.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainPageController());
  }
}
