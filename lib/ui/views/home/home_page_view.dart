import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt4_fullstack/ui/shared/text_style.dart';
import 'package:flutter_chatgpt4_fullstack/ui/shared/ui_helper.dart';
import 'package:flutter_chatgpt4_fullstack/ui/views/home/sub/home_page_stepper.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/getx/controllers/home_controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      //ResponsiveSizer package is used for a native design.
      builder: (context, orientation, screenType) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Obx(() => AnimatedOpacity(
                //Obx is used to pull variable changes from GetX.
                opacity: (controller.invisibleAllWidgets.value == true)
                    ? 0
                    : 1, //Here it is used to dim the screen when any of the skip buttons is pressed.
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const HomePageStepper(), //It is the class that ensures that all widgets in the top section are loaded.
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          //In this section, the widgets that will be created and changed when the "Continue" button is pressed are assigned.
                          stackMain(controller.lastStep.value),
                          _startedButtonAnimation(),
                          _skipPageButtonAnimation(controller.lastStep.value,
                              controller.fastStartController.value),
                          _skipButtonAnimation(),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  Widget stackMain(int lastStep) => SizedBox(
        //It is used to align the buttons inside the Stack widget and to prevent the widgets in the HomePageStepper class from sliding.
        height: (lastStep == 0) ? 75.w : 10.w,
        child: Container(),
      );

  Widget _skipButtonAnimation() {
    //The "Skip" button next to the "Continue" button.
    return AnimatedContainer(
        padding: EdgeInsets.only(top: 5.w, right: 17.w),
        duration: const Duration(
          seconds: 4,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        height: (controller.mainButtonsPrimary.value == 2) ? 50.w : 30.w,
        child: AnimatedOpacity(
          opacity: (controller.mainButtonsPrimary.value == 2) ? 1 : 0,
          duration: const Duration(seconds: 2),
          child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => controller.skipPage(),
                child: Container(
                  padding: EdgeInsets.all(SpaceValue().low),
                  child:
                      Text("Skip", style: TextStyles.homePageButtonsTextStyle),
                ),
              )),
        ));
  }

  Widget _skipPageButtonAnimation(int lastStep, bool fastStartController) {
    //The "Get Started" button next to the "Skip this page" button.
    return GestureDetector(
      onTap: () => controller.skipPage(),
      child: (lastStep == 0 && fastStartController == false)
          ? AnimatedContainer(
              duration: const Duration(
                seconds: 4,
              ),
              curve: Curves.fastLinearToSlowEaseIn,
              height:
                  (controller.mainButtonsSecondary.value == 1) ? 50.w : 30.w,
              child: AnimatedOpacity(
                opacity: (controller.mainButtonsSecondary.value == 1) ? 1 : 0,
                duration: const Duration(seconds: 1),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: skipPageButton,
                ),
              ))
          : Container(),
    );
  }

  Widget _startedButtonAnimation() {
    //Primary blue button animation
    return AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        duration: const Duration(
          seconds: 4,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        height: (controller.mainButtonsPrimary.value == 1)
            ? 65.w
            : (controller.mainButtonsPrimary.value == 2)
                ? 45.w
                : 30.w,
        child: AnimatedOpacity(
          opacity: (controller.mainButtonsPrimary.value == 1 ||
                  controller.mainButtonsPrimary.value == 2)
              ? 1
              : 0,
          duration: const Duration(seconds: 2),
          child: AnimatedAlign(
            duration: const Duration(seconds: 4),
            alignment: (controller.mainButtonsPrimary.value == 1 ||
                    controller.mainButtonsPrimary.value == 0)
                ? Alignment.topCenter
                : Alignment.centerRight,
            curve: Curves.fastLinearToSlowEaseIn,
            child: _getStartedButton(controller.mainButtonsPrimary.value, () {
              /*
Here, it is considered that the data is transferred to the other method by using the Void Callback
class and that it makes faster processing. In case the Step Count is 3, that is, if it is pressed
before the animations are loaded, the fast controller is called and the loading of the "skip this page"
button is disabled. In the main codes, it is used to move to the next step and to change the first
animations and alignmeny's. Finally, the animation is loaded with the timer and in case the number of
steps is more than 3, it is provided to go to the next page with the next controller.
              */
              if (controller.stepCount < 3) {
                if (controller.mainButtonsSecondary.value == 0) {
                  controller.fastStartController.value = true;
                }
                controller.mainButtonsPrimary.value = 2;
                controller.mainButtonsSecondary.value = 2;
                controller.stepCount.value = controller.stepCount.value + 1;
                Timer(
                  const Duration(milliseconds: 1000),
                  () {
                    controller.lastStep.value = controller.lastStep.value + 1;
                  },
                );
              } else {
                controller.skipPage();
              }
            }),
          ),
        ));
  }
}

Widget _getStartedButton(int buttonValue, VoidCallback callback) => Padding(
      //It is the function where the codes of the blue button are located, its width has been changed with the animated container.
      padding: EdgeInsets.symmetric(vertical: SpaceValue().mediumLow),
      child: GestureDetector(
        onTap: () => callback(),
        child: AnimatedContainer(
          duration: const Duration(
            seconds: 2,
          ),
          height: 11.w,
          curve: Curves.fastLinearToSlowEaseIn,
          width: (buttonValue == 1 || buttonValue == 0) ? 54.w : 45.w,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF00E0FF),
                    Color(0xFF0094FF),
                  ]),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E0FF).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 15,
                )
              ],
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            (buttonValue == 1) ? "Get Started" : "Continue",
            style: TextStyles.homePageButtonsBoldTextStyle,
          )),
        ),
      ),
    );

Widget get skipPageButton => Padding(
      //Skip page button
      padding: EdgeInsets.symmetric(vertical: SpaceValue().mediumLow),
      child: Container(
        height: 11.w,
        width: 54.w,
        decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
                blurRadius: 15,
              )
            ],
            borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Text(
          "Skip Page",
          style: TextStyles.homePageButtonsBoldTextStyle,
        )),
      ),
    );
