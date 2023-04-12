import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/controller/splash/splash_controller.dart';
import 'package:practical/utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Icon(
          Icons.person,
          color: AppColors.whiteColor,
          size: 100,
        ),
      ),
    );
  }
}
