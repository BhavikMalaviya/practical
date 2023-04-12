import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/utils/app_colors.dart';
import 'package:practical/utils/app_loader.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Get.back();
  }

  void show() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: const FullScreenLoader(),
      ),
      barrierColor: AppColors.primaryColor.withOpacity(0.1),
    );
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppLoader(),
    );
  }
}
