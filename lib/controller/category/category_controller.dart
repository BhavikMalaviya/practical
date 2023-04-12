import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/model/category_model.dart';
import 'package:practical/service/db.dart';

class CategoryController extends GetxController {
  TextEditingController categoryName = TextEditingController();
  RxString categoryNameError = "".obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isUpdate = false.obs;
  CategoryModel? categoryModel;
  @override
  void onInit() {
    getCategory();
    super.onInit();
  }

  bool validate() {
    RxBool isValid = true.obs;
    if (categoryName.text.isEmpty) {
      categoryNameError.value = "Please enter category name";
      isValid.value = false;
    }
    return isValid.value;
  }

  Future<void> getCategory() async {
    categoryList.clear();
    isLoading.value = true;
    categoryList.value = await DataBaseHelper().retriveCategory();
    isLoading.value = false;
  }

  Future<void> addCategory() async {
    isLoading.value = true;
    CategoryModel categoryModel = CategoryModel(
      categoryId: DateTime.now().millisecondsSinceEpoch,
      name: categoryName.text,
    );

    await DataBaseHelper().insertCategory(categoryModel);
    isLoading.value = false;
    getCategory();
    categoryName.clear();
  }

  Future<void> updateCategory(CategoryModel categoryModel) async {
    isLoading.value = true;
    await DataBaseHelper().updateCategory(categoryModel);
    isLoading.value = false;
    getCategory();
    categoryName.clear();
    isUpdate.value = false;
  }
}
