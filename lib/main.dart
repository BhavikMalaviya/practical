import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/routes/app_routes.dart';
import 'package:practical/service/db.dart';
import 'package:practical/utils/app_theme.dart';

import 'routes/app_pages.dart';
import 'utils/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DataBaseHelper().initializedDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splashScreen,
      title: AppConfig.appName,
      theme: AppTheme.themeData,
    );
  }
}
