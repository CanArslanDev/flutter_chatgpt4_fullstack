import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/getx/pages/pages.dart';
import 'core/getx/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: GetMaterialApp(
        //It was created as GetMaterialApp because the GetX package was used.
        title: 'Flutter ChatGPT-4',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            primary: const Color(0xFF00E0FF),
            background: const Color(0xFF0E1023),
            secondary: const Color(0xFF32344B),
            onSecondary: const Color(0xFF0197FF),
            onBackground: const Color(0xFF232738),
          ),
        ),
        initialRoute: Routes.mainPage,
        getPages: Pages.pages,
      ),
    );
  }
}
