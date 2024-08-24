import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const loadingDialogKey = "loadingDialogKey";
const loadingDialogWillPopKey = "loadingDialogWillPopKey";

class CustomProgressBar extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) {
    showDialog<void>(
      context: context,
      builder: (_) => CustomProgressBar(key: key),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: const Key(loadingDialogWillPopKey),
      onWillPop: () async => false,
      child: Center(
        key: const Key(loadingDialogKey),
        child: Platform.isAndroid
            ? const CircularProgressIndicator(
                color: Colors.black,
              )
            : const CupertinoActivityIndicator(
                color: Colors.black,
                radius: 20,
                animating: true,
              ),
      ),
    );
  }
}
