import 'package:flutter_chatgpt4_fullstack/core/getx/bindings/main_binding.dart';
import 'package:get/get.dart';

import '../../../ui/views/home/home_page_view.dart';
import '../../../ui/views/main/main_page_view.dart';
import '../bindings/home_binding.dart';
import '../routes/routes.dart';

abstract class Pages {
  static List<GetPage> pages = [
    GetPage(
        name: Routes.homePage,
        page: () => const HomePage(),
        binding: HomePageBinding()),
    GetPage(
        name: Routes.mainPage,
        page: () => const MainPage(),
        binding: MainPageBinding()),
  ];
}
