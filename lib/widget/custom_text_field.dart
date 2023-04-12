import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType? textInputType;
  final RxString error;
  final Function(String? v)? onChanged;
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.error,
    this.textInputType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      error.isNotEmpty ? Colors.red : AppColors.primaryColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              onChanged: onChanged,
              controller: textEditingController,
              keyboardType: textInputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
          Obx(
            () => error.isEmpty
                ? const SizedBox(
                    height: 8,
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "*${error.value}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
