import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'base_controller.dart';

class HomePageController extends BaseController {
  Rx<bool> invisibleAllWidgets = false
      .obs; //Makes all widgets invisible, this variable is used to navigate to the next page.
  Rx<int> mainButtonsPrimary =
      0.obs; //It is used to set the Alignment of the blue button.
  Rx<int> mainButtonsSecondary = 0
      .obs; //It is used to set the Alignment of the grey "skip this page" button.
  Rx<int> stepCount = 0.obs; //It is the variable used to count steps.
  Rx<int> lastStep = 0.obs; //Used to load widget animation for next step.
  Rx<bool> fastStartController = false
      .obs; //Animations are used to switch to the main page before they are fully loaded, this variable is used to load the animation of the "skip this page" button as a summary.

  void skipPage() {
    //It is used in page orientation.
    invisibleAllWidgets.value = true;
  }

  @override
  void onInit() {
    //Timer and mainButtonsPrimary/mainButtonsSecondary variables are used to load startup animations
    super.onInit();
    // ignore: avoid_print
    print("Starting home page controller");
    Timer(
      const Duration(seconds: 1),
      () {
        mainButtonsPrimary.value = 1;
      },
    );
    Timer(
      const Duration(seconds: 2),
      () {
        mainButtonsSecondary.value = 1;
      },
    );
  }
}
