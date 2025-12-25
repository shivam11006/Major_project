import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error }

void showAppSnackbar({
  required BuildContext context,
  required SnackbarType type, // ✅ FIXED ENUM NAME
  required String description,
}) {
  switch (type) {
    case SnackbarType.success:
      CherryToast.success(
        toastDuration: const Duration(milliseconds: 3000), // ✅ FIXED
        height: 70,
        toastPosition: Position.top,
        shadowColor: Colors.white,
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        backgroundColor: Colors.green.withAlpha(40),
        description: Text(
          description,
          style: const TextStyle(color: Colors.green),
        ),
        title: const Text(
          "Successfully Updated...",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ).show(context);
      break;

    case SnackbarType.error:
      CherryToast.error(
        toastDuration: const Duration(milliseconds: 2000), // ✅ FIXED
        height: 70,
        toastPosition: Position.top,
        shadowColor: Colors.white,
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        backgroundColor: Colors.red.withAlpha(40),
        description: Text(
          description,
          style: const TextStyle(color: Colors.red),
        ),
        title: const Text(
          "Something Went wrong...",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ).show(context);
      break;
  }
}
