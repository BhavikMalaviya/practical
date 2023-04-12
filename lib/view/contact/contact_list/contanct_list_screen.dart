import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/controller/contact/contact_list/contact_list_controller.dart';
import 'package:practical/model/user_model.dart';
import 'package:practical/routes/app_routes.dart';
import 'package:practical/service/db.dart';
import 'package:practical/utils/app_assets.dart';
import 'package:practical/utils/app_colors.dart';
import 'package:practical/utils/app_loader.dart';
import 'package:practical/view/category/category_screen.dart';
import 'package:practical/view/contact/add_contact/add_contact_screen.dart';
import 'package:practical/view/drawer/drawer_screen.dart';
import 'package:practical/widget/app_bar.dart';
import 'package:practical/widget/custom_text_field.dart';

class ContactListScreen extends StatelessWidget {
  ContactListScreen({super.key});
  final ContactListController _con = Get.put(ContactListController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _con.scaffoldState,
        appBar: appbar(
          title: _con.fragment.value == 0
              ? "Contact List"
              : _con.fragment.value == 1
                  ? "Create and store category"
                  : "Add Contact",
          onTap: () => _con.scaffoldState.currentState?.openDrawer(),
          actions: _con.fragment.value == 0
              ? [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        backgroundColor: AppColors.whiteColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _con.userFilter(
                                  _con.categoryList[index].categoryId),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(_con.categoryList[index].name),
                              ),
                            );
                          },
                          itemCount: _con.categoryList.length,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Image.asset(
                        AppAssets.filter,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Obx(() => _con.userList.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _con.isSearch.toggle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                            child: (_con.isSearch.isFalse)
                                ? Image.asset(
                                    AppAssets.search,
                                    height: 22,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: AppColors.darkColor.withOpacity(0.5),
                                    size: 25,
                                  ),
                          ),
                        )
                      : Container()),
                ]
              : [],
        ),
        drawer: const DrawerScreen(),
        body: Obx(
          () => _con.fragment.value == 1
              ? CategoryScreen()
              : _con.fragment.value == 2
                  ? AddContactScreen()
                  : Column(
                      children: [
                        Obx(
                          () => _con.isSearch.value
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: CustomTextField(
                                    hintText: "Search",
                                    textEditingController: _con.search,
                                    error: "".obs,
                                    onChanged: (v) {
                                      if (_con.search.text.isNotEmpty) {
                                        _con.userSearch();
                                      } else {
                                        _con.searchList.clear();
                                        _con.searchList.addAll(_con.userList);
                                      }
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        Expanded(
                          child: Obx(
                            () => _con.isLoading.value
                                ? const AppLoader()
                                : _con.searchList.isEmpty
                                    ? const Center(
                                        child: Text(
                                          "No Contact Available",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        itemCount: _con.searchList.length,
                                        padding: const EdgeInsets.all(15),
                                        separatorBuilder: (ctx, index) {
                                          return Container(
                                            height: 1,
                                            color: AppColors.dividerColor,
                                          );
                                        },
                                        itemBuilder: (ctx, index) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 15),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        AppColors.darkgreen,
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      child: Image.file(
                                                        File(
                                                          _con.searchList[index]
                                                              .profileImage,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "${_con.searchList[index].firstName} ${_con.searchList[index].lastName}"),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Get.toNamed(
                                                    AppRoutes.addContactScreen,
                                                    arguments:
                                                        _con.searchList[index],
                                                  ),
                                                  child: Image.asset(
                                                      AppAssets.edit,
                                                      height: 22),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () => deleteDialog(
                                                      context, index),
                                                  child: Image.asset(
                                                    AppAssets.delete,
                                                    height: 22,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Future<void> deleteDialog(context, index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                child: const Text(
                  'YES',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  DataBaseHelper().deleteUser(_con.searchList[index].userId);
                  _con.searchList.removeAt(index);
                  _con.userList.removeWhere((UserModel userModel) =>
                      userModel.userId == _con.searchList[index].userId);
                  Get.back();
                },
              ),
              TextButton(
                child: const Text(
                  'NO',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
