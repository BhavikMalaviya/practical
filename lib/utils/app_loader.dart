import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppLoader extends StatelessWidget {
  static late Size size;
  final double loadersize;
  final double width;
  const AppLoader({Key? key, this.loadersize = 0.08, this.width = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: size.width * loadersize,
              height: size.width * loadersize,
              child: getLoader(width),
            ),
          ],
        ),
      ),
    );
  }

  getLoader(double width) {
    if (Platform.isIOS) {
      return const CupertinoActivityIndicator();
    } else {
      return CircularProgressIndicator(
        strokeWidth: width,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      );
    }
  }
}
