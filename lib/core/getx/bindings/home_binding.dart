import 'package:flutter_chatgpt4_fullstack/core/getx/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
