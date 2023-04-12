import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/controller/category/category_controller.dart';
import 'package:practical/service/db.dart';
import 'package:practical/utils/app_assets.dart';
import 'package:practical/utils/app_colors.dart';
import 'package:practical/utils/app_loader.dart';
import 'package:practical/widget/app_button.dart';
import 'package:practical/widget/custom_text_field.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  final CategoryController _con = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: CustomTextField(
            hintText: "Add Category",
            textEditingController: _con.categoryName,
            error: _con.categoryNameError,
          ),
        ),
        Obx(
          () => Center(
            child: AppButton(
              buttontext: _con.isUpdate.value ? "Update" : "Save",
              radius: 0,
              height: 45,
              width: 150,
              onPressed: () {
                if (_con.validate()) {
                  if (_con.isUpdate.value) {
                    _con.categoryModel?.name = _con.categoryName.text;
                    _con.updateCategory(_con.categoryModel!);
                  } else {
                    _con.addCategory();
                  }
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => _con.isLoading.value
                ? const AppLoader()
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        color: AppColors.lightdarkOrange,
                      );
                    },
                    itemCount: _con.categoryList.length,
                    padding: const EdgeInsets.all(15),
                    itemBuilder: (ctx, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: AppColors.lightOrange,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_con.categoryList[index].name),
                            ),
                            GestureDetector(
                              onTap: () {
                                _con.categoryName.clear();
                                _con.categoryName.text =
                                    _con.categoryList[index].name;
                                _con.categoryModel = _con.categoryList[index];
                                _con.isUpdate.value = true;
                              },
                              child: Image.asset(AppAssets.edit, height: 22),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                deleteDialog(context, index);
                              },
                              child: Image.asset(AppAssets.delete, height: 22),
                            )
                          ],
                        ),
                      );
                    }),
          ),
        ),
      ]),
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
                  DataBaseHelper()
                      .deleteCategory(_con.categoryList[index].categoryId);
                  _con.categoryList.removeAt(index);
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
