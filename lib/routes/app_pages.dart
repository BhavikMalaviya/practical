import 'package:get/get.dart';
import 'package:practical/view/category/category_screen.dart';
import 'package:practical/view/contact/add_contact/add_contact_screen.dart';
import 'package:practical/view/contact/contact_list/contanct_list_screen.dart';
import 'package:practical/view/splash/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.categoryScreen,
      page: () => CategoryScreen(),
    ),
    GetPage(
      name: AppRoutes.contactListScreen,
      page: () => ContactListScreen(),
    ),
    GetPage(
      name: AppRoutes.addContactScreen,
      page: () => AddContactScreen(),
    ),
  ];
}
