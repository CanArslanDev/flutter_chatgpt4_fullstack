import 'dart:async';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/getx/controllers/main_controller.dart';

class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FlutterMentionsState>
        textFieldController = //It is used to control the text in the TextField.
        GlobalKey<FlutterMentionsState>();
    ScrollController scrollController =
        ScrollController(); //It is used to scroll the ListView down.
    return ResponsiveSizer(
      //It is used for the application to run as native.
      builder: (context, orientation, screenType) => Obx(() => Scaffold(
          //Obx is used to change the data instantly from the controller.
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: AnimatedOpacity(
                //Animation is provided with AnimatedOpacity.
                duration: const Duration(seconds: 3),
                curve: Curves.fastLinearToSlowEaseIn,
                opacity: (controller.startingAnimation.value == true) ? 1 : 0,
                child: const Text('ChatGPT')),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: controller.messageList.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  //Here, message bubbles are called according to the data from the message list variable in the controller.
                  String key = controller.messageList[index]['messageText'];
                  if (controller.messageList[index]['messageSended'] ==
                      "chatgpt_text") {
                    return _ChatGPTText(contextMessage: key);
                  } else if (controller.messageList[index]['messageSended'] ==
                      "chatgpt_image") {
                    return _ChatGPTImage(contextMessage: key);
                  } else {
                    return _UserText(contextMessage: key);
                  }
                },
              )),
              AnimatedSlide(
                //It is used to make the TextField come from bottom to top.
                duration: const Duration(seconds: 3),
                curve: Curves.fastLinearToSlowEaseIn,
                offset: Offset(
                    0, (controller.startingAnimation.value == true) ? 0 : 1.5),
                child: Column(
                  children: [
                    _customDivider,
                    Container(
                      padding: EdgeInsets.only(top: 3.5.w),
                      width: 87.w,
                      child: FlutterMentions(
                        //It runs slash (/) commands with flutter_mentions library.
                        style: TextStyle(color: Colors.white, fontSize: 4.w),
                        key: textFieldController,
                        onChanged: (value) {
                          //Here, it draws which command is used with the flutter_mentions library and acts accordingly.
                          String text = textFieldController
                              .currentState!.controller!.markupText;
                          if (text.contains('/[__image__]') == true) {
                            controller.textFormSelectionValue = "image";
                            controller.mentionClear();
                          } else if (text.contains('/[__text__]')) {
                            controller.textFormSelectionValue = "text";
                            controller.mentionClear();
                          } else {
                            controller.mentionReset();
                          }
                        },
                        suggestionPosition: SuggestionPosition.Top,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.onBackground,
                          filled: true,
                          hintText: 'Type anything...',
                          hintStyle: GoogleFonts.inter(color: Colors.white24),
                          // errorText: errorTxt,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 4.5.w,
                            horizontal: 4.w,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              String text = textFieldController
                                  .currentState!.controller!.text;
                              if (controller.textFormSelectionValue == "") {
                                Get.snackbar("No selection made",
                                    "Please choose /text or /image.");
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 500),
                                );
                              } else {
                                controller.messageList.add({
                                  'messageText': textFieldController
                                      .currentState!.controller!.text,
                                  'messageSended': 'user'
                                });
                                controller.sendChatGPTMessage(text);

                                textFieldController
                                    .currentState!.controller!.text = "";
                                controller.textFormSelectionValue = "";
                                scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    curve: Curves.easeOut,
                                    duration:
                                        const Duration(milliseconds: 500));
                              }
                            },
                            child: SizedBox(
                              width: 12.w,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 1.w),
                                  height: 12.w,
                                  width: 12.w,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  child: Icon(
                                    FontAwesomeIcons.paperPlane,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          hoverColor: const Color(0xFF444442),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(width: 0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(width: 0)),
                          focusColor: Colors.white,
                        ),
                        mentions: [
                          Mention(
                              trigger: '/',
                              style: const TextStyle(
                                color: Colors.amber,
                              ),
                              data: controller.textFieldMentionData,
                              matchAll: false,
                              suggestionBuilder: (data) {
                                return Container(
                                  padding: const EdgeInsets.all(10.0),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          data['photo'],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            data['full_name'],
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '@${data['display']}',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )))),
    );
  }
}

/*
Here, the speech bubbles are stateful so that they are animated and
do not take up too much space in the GetxController.

Separately, customDivider is used because it works more stable than
the widget with Divider(). For example, in some cases, while the
Divider is displayed on the screen, pixel shift may occur.
*/

class _UserText extends StatefulWidget {
  const _UserText({required this.contextMessage});
  final String contextMessage;
  @override
  State<_UserText> createState() => _UserTextState();
}

class _UserTextState extends State<_UserText> {
  ValueNotifier<bool> animateOpacity = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(), () => animateOpacity.value = true);
    return ValueListenableBuilder(
        valueListenable: animateOpacity,
        builder:
            (BuildContext context, bool animateOpacityVoid, Widget? child) {
          return AnimatedSlide(
            duration: const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            offset: Offset((animateOpacityVoid == true) ? 0 : 0.8, 0),
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: (animateOpacityVoid == true) ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 1.w, bottom: 1.w, right: 1.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 10.w),
                    width: 70.w,
                    padding: EdgeInsets.only(left: 2.w, top: 1.w),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Theme.of(Get.context!).colorScheme.onBackground),
                    child: Text(
                      widget.contextMessage,
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 5.w),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Widget get _customDivider => Container(
      height: 0.3.w,
      color: const Color(0xFF232738),
    );

class _ChatGPTText extends StatefulWidget {
  const _ChatGPTText({required this.contextMessage});
  final String contextMessage;
  @override
  State<_ChatGPTText> createState() => _ChatGPTTextState();
}

class _ChatGPTTextState extends State<_ChatGPTText> {
  ValueNotifier<bool> animateOpacity = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(), () => animateOpacity.value = true);
    return ValueListenableBuilder(
        valueListenable: animateOpacity,
        builder:
            (BuildContext context, bool animateOpacityVoid, Widget? child) {
          return AnimatedSlide(
            duration: const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            offset: Offset((animateOpacityVoid == true) ? 0 : -0.8, 0),
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: (animateOpacityVoid == true) ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 1.w, bottom: 1.w, left: 1.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 10.w),
                    width: 70.w,
                    padding: EdgeInsets.only(left: 2.w, top: 1.w),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Theme.of(Get.context!).colorScheme.onSurface),
                    child: Text(
                      widget.contextMessage,
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 5.w),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _ChatGPTImage extends StatefulWidget {
  const _ChatGPTImage({required this.contextMessage});
  final String contextMessage;
  @override
  State<_ChatGPTImage> createState() => _ChatGPTImageState();
}

class _ChatGPTImageState extends State<_ChatGPTImage> {
  ValueNotifier<bool> animateOpacity = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(), () => animateOpacity.value = true);
    return ValueListenableBuilder(
        valueListenable: animateOpacity,
        builder:
            (BuildContext context, bool animateOpacityVoid, Widget? child) {
          return AnimatedSlide(
            duration: const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            offset: Offset((animateOpacityVoid == true) ? 0 : -0.8, 0),
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: (animateOpacityVoid == true) ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 1.w, bottom: 1.w, left: 1.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedSize(
                    duration: const Duration(seconds: 3),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        constraints: BoxConstraints(minHeight: 10.w),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color:
                                Theme.of(Get.context!).colorScheme.onSurface),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(widget.contextMessage))),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
