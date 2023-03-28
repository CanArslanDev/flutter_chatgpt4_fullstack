import 'package:get/get.dart';

import '../../../ui/views/home/home_page_view.dart';
import '../bindings/home_binding.dart';
import '../routes/routes.dart';

abstract class Pages {
  static List<GetPage> pages = [
    GetPage(
        name: Routes.homePage,
        page: () => const HomePage(),
        binding: HomePageBinding()),
  ];
}
