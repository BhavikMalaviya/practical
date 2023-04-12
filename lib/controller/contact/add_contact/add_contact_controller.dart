import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical/controller/contact/contact_list/contact_list_controller.dart';
import 'package:practical/model/category_model.dart';
import 'package:practical/model/user_model.dart';
import 'package:practical/service/db.dart';

import '../../../utils/app_colors.dart';

class AddContactController extends GetxController {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  RxString firstNameError = "".obs;
  RxString lastNameError = "".obs;
  RxString mobileError = "".obs;
  RxString emailError = "".obs;
  RxString profileImage = "".obs;
  RxString profileImageError = "".obs;
  RxString categoryError = "".obs;
  Rx<CategoryModel> categoryModel = CategoryModel(categoryId: 0, name: "").obs;
  UserModel? userModel;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      userModel = Get.arguments;
      firstName.text = userModel?.firstName ?? "";
      lastName.text = userModel?.lastName ?? "";
      mobileNo.text = userModel?.mobileNo ?? "";
      email.text = userModel?.email ?? "";
      profileImage.value = userModel?.profileImage ?? "";
    }
    await getCategory();
    super.onInit();
  }

  bool validate() {
    RxBool isValid = true.obs;
    firstNameError.value = "";
    lastNameError.value = "";
    mobileError.value = "";
    emailError.value = "";
    profileImageError.value = "";
    categoryError.value = "";
    if (firstName.text.isEmpty) {
      firstNameError.value = "Please enter first name";
      isValid.value = false;
    }
    if (lastName.text.isEmpty) {
      lastNameError.value = "Please enter last name";
      isValid.value = false;
    }
    if (mobileNo.text.isEmpty) {
      mobileError.value = "Please enter mobile number";
      isValid.value = false;
    }
    if (email.text.isEmpty) {
      emailError.value = "Please enter email";
      isValid.value = false;
    } else if (!GetUtils.isEmail(email.text)) {
      emailError.value = "Please enter valid email";
      isValid.value = false;
    }
    if (profileImage.isEmpty) {
      profileImageError.value = "Please select profile";
      isValid.value = false;
    }
    if (categoryModel.value.name.isEmpty) {
      categoryError.value = "Please select category";
      isValid.value = false;
    }
    return isValid.value;
  }

  Future<void> getCategory() async {
    categoryList.clear();
    categoryModel.value = CategoryModel(categoryId: 0, name: "");
    isLoading.value = true;
    categoryList.value = await DataBaseHelper().retriveCategory();
    if (categoryList.isNotEmpty) {
      categoryModel.value =
          categoryList.firstWhereOrNull((CategoryModel categoryModel) {
                return categoryModel.categoryId == userModel?.categoryId;
              }) ??
              CategoryModel(categoryId: 0, name: "");
    }
    isLoading.value = false;
  }

  Future<void> addUser() async {
    isLoading.value = true;

    UserModel userModelDetails = UserModel(
      categoryId: categoryModel.value.categoryId,
      email: email.text,
      firstName: firstName.text,
      lastName: lastName.text,
      mobileNo: mobileNo.text,
      profileImage: profileImage.value,
      userId: DateTime.now().millisecondsSinceEpoch,
    );

    await DataBaseHelper().insertUser(userModelDetails);
    isLoading.value = false;
    Get.find<ContactListController>().getUser();
    Get.find<ContactListController>().fragment.value = 0;
  }

  Future<void> updateUser() async {
    isLoading.value = true;
    UserModel userModelDetails = UserModel(
      categoryId: categoryModel.value.categoryId,
      email: email.text,
      firstName: firstName.text,
      lastName: lastName.text,
      mobileNo: mobileNo.text,
      profileImage: profileImage.value,
      userId: userModel?.userId ?? 0,
    );

    await DataBaseHelper().updateUser(userModelDetails);
    isLoading.value = false;
    Get.find<ContactListController>().getUser();
    Get.back();
  }

  Future<void> selectionOfImage(context) async {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.camera,
                color: AppColors.primaryColor,
              ),
              title: const Text(
                "Camera",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Get.back();
                await pickImage(false);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.image,
                color: AppColors.primaryColor,
              ),
              title: const Text(
                "Gallery",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Get.back();
                await pickImage(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImage(bool fromGallery) async {
    XFile? pickedFile;
    try {
      pickedFile = await ImagePicker().pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        maxHeight: 500,
        maxWidth: 500,
      );
    } catch (e) {
      log(e.toString());
    }
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
          compressQuality: 50,
          cropStyle: CropStyle.circle,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "edit".tr,
              statusBarColor: Colors.black,
              toolbarColor: AppColors.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: "edit".tr,
            ),
          ]);
      if (croppedFile != null) {
        profileImage.value = File(croppedFile.path).path;
      }
    } else {
      return;
    }
  }
}
