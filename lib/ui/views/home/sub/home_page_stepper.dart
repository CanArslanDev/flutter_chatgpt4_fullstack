import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt4_fullstack/ui/shared/text_style.dart';
import 'package:flutter_chatgpt4_fullstack/ui/shared/ui_helper.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/getx/controllers/home_controller.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class HomePageStepper extends GetView<HomePageController> {
  const HomePageStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //Obx is used to pull variable changes from GetX.
      return Container(
          child: widgetController(
              controller.stepCount.value, controller.lastStep.value));
    });
  }
}

Widget widgetController(int step, int lastStep) {
  if (lastStep == 0) {
    //It causes the Start widget to rotate when the number of steps is 0.
    return const _LoginView();
  } else {
    //If Step number is greater than 0, it starts loading step widgets.
    ValueNotifier<bool> showStepBar = ValueNotifier(false);
    Timer(
      const Duration(),
      () {
        //This timer it aims to load the animation of step widgets with a very short delay.
        showStepBar.value = true;
      },
    );

    return ValueListenableBuilder(
        //ValueNotifier is used for animation control.
        valueListenable: showStepBar,
        builder: (BuildContext context, bool showStepBarValue, Widget? child) {
          return Expanded(
            child: Column(
              children: [
                stepBar(showStepBarValue, step),
                stepImage(
                    "Remember that ChatGPT is under development, you may give wrong information or encounter different errors.",
                    UIHelper().homeStep1Image,
                    showStepBarValue,
                    step,
                    lastStep,
                    1),
                stepImage(
                    "You can ask questions visually and in text using the / commands to the artificial intelligence.",
                    UIHelper().homeStep2Image,
                    showStepBarValue,
                    step,
                    lastStep,
                    2),
                stepImage(
                    "Get started with ChatGPT-4!",
                    UIHelper().homeStep3Image,
                    showStepBarValue,
                    step,
                    lastStep,
                    3),
              ],
            ),
          );
        });
  }
}

Widget stepImage(String desc, String imagePath, bool stepBarValue, int step,
        int lastStep, int defaultValue) =>
    //Allows loading of the photo and text of the step widgets.
    Container(
      child: (lastStep == defaultValue)
          ? AnimatedSlide(
              //The AnimatedSlide widget is used to make the widgets appear from left to right.
              offset: Offset(
                  (stepBarValue == true || step - 1 == defaultValue)
                      ? (step == defaultValue)
                          ? 0
                          : 1.5
                      : -1.25,
                  0),
              duration: const Duration(seconds: 5),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Padding(
                padding: EdgeInsets.only(top: SpaceValue().high),
                child: Column(
                  children: [
                    Image.asset(imagePath),
                    Padding(
                      padding: EdgeInsets.only(top: SpaceValue().veryHigh),
                      child: SizedBox(
                        width: 70.w,
                        child: Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 5.7.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );

Widget stepBar(bool stepBarValue, int step) => AnimatedSlide(
      //The top progress bar on the step page.
      offset: Offset(0, (stepBarValue == true || step > 1) ? 0 : -1),
      duration: const Duration(seconds: 5),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: SpaceValue().high, left: SpaceValue().low),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Step $step/3",
                style: TextStyles.homePageButtonsBoldTextStyle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SpaceValue().veryLow),
            child: SimpleAnimationProgressBar(
              ratio: step / 3,
              width: 93.w,
              height: 2.5.w,
              direction: Axis.horizontal,
              backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
              foregrondColor: Theme.of(Get.context!).colorScheme.onSecondary,
              duration: const Duration(seconds: 5),
              curve: Curves.fastLinearToSlowEaseIn,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
    );

class _LoginView extends GetView<HomePageController> {
  //It is a class created for sequential loading of opacity animations of texts.
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> loginPagePictureTime = ValueNotifier(false);
    ValueNotifier<bool> loginPageTextTime = ValueNotifier(false);
    ValueNotifier<bool> loginPageDescTime = ValueNotifier(false);
    //An animation time is determined for each text with the timer.
    _timer500ms(() {
      loginPagePictureTime.value = true;
    });
    _timer1000ms(() {
      loginPageTextTime.value = true;
    });
    _timer1500ms(() {
      loginPageDescTime.value = true;
    });
    return Obx(() => AnimatedSlide(
          //AnimatedSlide is used to make the widget go from left to right.
          offset: Offset((controller.stepCount.value == 0) ? 0 : 1.3,
              0), //The offset control is provided by the stepCount variable in the GetXController.
          duration: const Duration(seconds: 5),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Column(
            children: [
              _gptImage(loginPagePictureTime),
              mainText(loginPageTextTime),
              descText(loginPageDescTime),
            ],
          ),
        ));
  }
}

Widget _gptImage(ValueNotifier<bool> value) => ValueListenableBuilder(
    //This widget returns the Initial photo.
    valueListenable: value,
    builder: (BuildContext context, bool loginPageWidget, Widget? child) {
      return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: (value.value == true) ? 1 : 0,
        child: Image.asset(
          "assets/images/homePageGPTIcon.png",
          width: 80.w,
        ),
      );
    });

Widget mainText(ValueNotifier<bool> value) => ValueListenableBuilder(
    //Returns the initial main text.
    valueListenable: value,
    builder: (BuildContext context, bool loginPageWidget, Widget? child) {
      return Padding(
        padding: EdgeInsets.only(top: SpaceValue().medium),
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: (value.value == true) ? 1 : 0,
          child: Text("Try the new ChatGPT-4!",
              textAlign: TextAlign.center,
              style: TextStyles.homePageTitleTextStyle),
        ),
      );
    });

Widget descText(ValueNotifier<bool> value) => ValueListenableBuilder(
    //Returns the initial description text.
    valueListenable: value,
    builder: (BuildContext context, bool loginPageWidget, Widget? child) {
      return Padding(
        padding: EdgeInsets.only(top: SpaceValue().mediumLow),
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: (value.value == true) ? 1 : 0,
          child: Text(
              "This App allows you to try\nChatGPT-4 both in text and image.",
              textAlign: TextAlign.center,
              style: TextStyles.homePageDescTextStyle),
        ),
      );
    });
void _timer500ms(VoidCallback callback) {
  //Timers are included in the function so that the codes are not long.
  Timer(
    const Duration(milliseconds: 500),
    () {
      callback();
    },
  );
}

void _timer1000ms(VoidCallback callback) {
  //Timers are included in the function so that the codes are not long.
  Timer(
    const Duration(milliseconds: 1000),
    () {
      callback();
    },
  );
}

void _timer1500ms(VoidCallback callback) {
  //Timers are included in the function so that the codes are not long.
  Timer(
    const Duration(milliseconds: 1500),
    () {
      callback();
    },
  );
}
