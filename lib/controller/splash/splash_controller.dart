import 'package:get/get.dart';
import 'package:practical/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.contactListScreen);
    });
    super.onInit();
  }
}
