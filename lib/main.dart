import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:sample_ecommerce/config/firebase/firebase_handler.dart';
import 'package:sample_ecommerce/modules/login/auth_service/auth_service.dart';
import 'package:sample_ecommerce/modules/login/presentation/screen/login_screen.dart';
import 'package:sample_ecommerce/modules/product/presentation/screen/product_list_screen.dart';
import 'package:sample_ecommerce/utils/sp_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHandler().initializeFirebase();
  await SPUtil.getInstance();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode currentThemeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      currentThemeMode = currentThemeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: themeData,
        themeMode: currentThemeMode,
        home: AuthService.user != null
            ? const ProductListingScreen()
            : const LoginScreen());
  }
}
