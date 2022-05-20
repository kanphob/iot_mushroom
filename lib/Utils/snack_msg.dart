import 'package:flutter/material.dart';

class SnackBarMsg {
  static SnackBar snackBarMsg({
    required String sText,
  }) {
    return SnackBar(
      content: Text(sText),
      duration: const Duration(seconds: 5),
      elevation: 5,
    );
  }
}
