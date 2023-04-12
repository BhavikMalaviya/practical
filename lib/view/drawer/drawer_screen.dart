import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/controller/category/category_controller.dart';
import 'package:practical/controller/contact/add_contact/add_contact_controller.dart';
import 'package:practical/controller/contact/contact_list/contact_list_controller.dart';
import 'package:practical/utils/app_colors.dart';
import 'package:practical/widget/app_bar.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkColor,
      child: ListView(children: [
        appbar(
          leading: Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkColor.withOpacity(0.5),
          ),
        ),
        title(
          title: "Add Category",
          onTap: () {
            Get.back();
            Get.find<ContactListController>().fragment.value = 1;
            Get.put(CategoryController()).getCategory();
          },
        ),
        Container(
          color: AppColors.primaryColor.withOpacity(0.5),
          width: double.infinity,
          height: 1,
        ),
        title(
          title: "Add Contact",
          onTap: () {
            Get.back();
            Get.find<ContactListController>().fragment.value = 2;
            Get.put(AddContactController()).getCategory();
          },
        ),
        Container(
          color: AppColors.primaryColor.withOpacity(0.5),
          width: double.infinity,
          height: 1,
        ),
        title(
          title: "Contact List",
          onTap: () {
            Get.back();
            Get.find<ContactListController>().fragment.value = 0;
            Get.put(ContactListController()).getCategory();
            Get.put(ContactListController()).getUser();
          },
        ),
        Container(
          color: AppColors.primaryColor.withOpacity(0.5),
          width: double.infinity,
          height: 1,
        ),
      ]),
    );
  }

  Widget title({required String title, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
