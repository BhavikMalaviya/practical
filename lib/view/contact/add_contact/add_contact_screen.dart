import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/controller/contact/add_contact/add_contact_controller.dart';
import 'package:practical/controller/contact/contact_list/contact_list_controller.dart';
import 'package:practical/model/category_model.dart';
import 'package:practical/utils/app_colors.dart';
import 'package:practical/utils/app_loader.dart';
import 'package:practical/utils/globle.dart';
import 'package:practical/widget/app_bar.dart';
import 'package:practical/widget/app_button.dart';
import 'package:practical/widget/custom_text_field.dart';

class AddContactScreen extends StatelessWidget {
  AddContactScreen({super.key});
  final AddContactController _con = Get.put(AddContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _con.userModel != null
          ? appbar(
              leading: Icon(
                Icons.arrow_back_ios,
                color: AppColors.darkColor.withOpacity(0.5),
              ),
              title: "Update contact",
            )
          : null,
      body: Obx(
        () => _con.isLoading.value
            ? const AppLoader()
            : ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () => _con.selectionOfImage(context),
                      child: CircleAvatar(
                        backgroundColor: _con.profileImageError.isNotEmpty
                            ? Colors.red.withOpacity(0.1)
                            : AppColors.primaryColor.withOpacity(0.2),
                        radius: 70,
                        child: _con.profileImage.value.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: _con.profileImageError.isNotEmpty
                                    ? Colors.red.withOpacity(0.5)
                                    : AppColors.primaryColor.withOpacity(0.5),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _con.profileImage.value.contains("http")
                                    ? Image.network(_con.profileImage.value)
                                    : Image.file(
                                        File(_con.profileImage.value),
                                      ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: "First name",
                    textEditingController: _con.firstName,
                    error: _con.firstNameError,
                  ),
                  CustomTextField(
                    hintText: "Last name",
                    textEditingController: _con.lastName,
                    error: _con.lastNameError,
                  ),
                  CustomTextField(
                    hintText: "Mobile Number",
                    textEditingController: _con.mobileNo,
                    error: _con.mobileError,
                    textInputType: TextInputType.phone,
                  ),
                  CustomTextField(
                    hintText: "Email",
                    textEditingController: _con.email,
                    error: _con.emailError,
                    textInputType: TextInputType.emailAddress,
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        if (_con.categoryList.isEmpty) {
                          toast("First you need to add category");
                          Get.find<ContactListController>().fragment.value = 1;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _con.categoryError.isNotEmpty
                                  ? Colors.red
                                  : AppColors.primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<CategoryModel>(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          underline: Container(),
                          isExpanded: true,
                          value: _con.categoryModel.value.name.isEmpty
                              ? null
                              : _con.categoryModel.value,
                          hint: const Text("Category"),
                          items: _con.categoryList.map((CategoryModel items) {
                            return DropdownMenuItem<CategoryModel>(
                              value: items,
                              child: Text(items.name),
                            );
                          }).toList(),
                          onChanged: (CategoryModel? newValue) {
                            if (newValue != null) {
                              _con.categoryModel.value = newValue;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => _con.categoryError.isEmpty
                        ? const SizedBox(
                            height: 8,
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "*${_con.categoryError.value}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: AppButton(
                      buttontext: _con.userModel == null ? "Save" : "Update",
                      radius: 0,
                      height: 45,
                      width: 150,
                      onPressed: () {
                        if (_con.validate()) {
                          if (_con.userModel != null) {
                            _con.updateUser();
                          } else {
                            _con.addUser();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
