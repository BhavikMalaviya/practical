import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/utils/app_colors.dart';

PreferredSizeWidget appbar(
    {Function()? onTap,
    Widget? leading,
    String? title,
    List<Widget>? actions}) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    leading: GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: leading ??
          Icon(
            Icons.menu,
            color: AppColors.darkColor.withOpacity(0.5),
          ),
    ),
    title: Text(
      title ?? '',
      style: const TextStyle(color: AppColors.whiteColor),
    ),
    centerTitle: true,
    actions: actions,
  );
}
