import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/model/category_model.dart';
import 'package:practical/model/user_model.dart';
import 'package:practical/service/db.dart';

class ContactListController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController search = TextEditingController();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> searchList = <UserModel>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  RxInt fragment = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
    getCategory();
  }

  void userSearch() {
    searchList.value = userList
        .where((UserModel userModel) => ((userModel.firstName
                .toLowerCase()
                .contains(search.text.toLowerCase())) ||
            userModel.lastName
                .toLowerCase()
                .contains(search.text.toLowerCase())))
        .toList();
  }

  void userFilter(int categoryid) {
    searchList.value = userList
        .where((UserModel userModel) => userModel.categoryId == categoryid)
        .toList();
    Get.back();
  }

  Future<void> getUser() async {
    userList.clear();
    searchList.clear();
    isLoading.value = true;
    userList.value = await DataBaseHelper().retriveUser();
    searchList.addAll(userList);
    isLoading.value = false;
  }

  Future<void> getCategory() async {
    categoryList.clear();
    isLoading.value = true;
    categoryList.value = await DataBaseHelper().retriveCategory();
    isLoading.value = false;
  }
}
