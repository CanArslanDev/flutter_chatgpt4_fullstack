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
    GlobalKey<FlutterMentionsState> textFieldController =
        GlobalKey<FlutterMentionsState>();
    return ResponsiveSizer(
      builder: (context, orientation, screenType) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text('ChatGPT'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Obx(() => SafeArea(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: controller.messageList.length,
                    itemBuilder: (context, index) {
                      print(controller.messageList[index]);
                      String key = controller.messageList[index]['messageText'];
                      return Text(
                        key,
                        style: GoogleFonts.inter(color: Colors.white),
                      );
                    },
                  )),
                  Container(
                    height: 0.3.w,
                    color: const Color(0xFF232738),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 3.5.w),
                    width: 87.w,
                    child: FlutterMentions(
                      style: TextStyle(color: Colors.white, fontSize: 4.w),
                      key: textFieldController,
                      onChanged: (value) {
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
                          onTap: () {
                            controller.messageList.add({
                              'messageText': textFieldController
                                  .currentState!.controller!.text,
                              'messageSended': 'user'
                            });
                            textFieldController.currentState!.controller!.text =
                                "";
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
                                    shape: BoxShape.circle, color: Colors.blue),
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
                                padding: EdgeInsets.all(10.0),
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
              )))),
    );
  }
}
