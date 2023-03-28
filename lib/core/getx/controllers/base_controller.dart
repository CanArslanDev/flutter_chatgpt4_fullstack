import 'package:get/get.dart';

class BaseController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // ignore: avoid_print
    print("Starting base controller");
  }

  @override
  void onClose() {
    super.onClose();
    // ignore: avoid_print
    print("Starting base controller");
  }
}
