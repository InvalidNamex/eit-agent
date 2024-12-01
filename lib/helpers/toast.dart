import 'package:eit/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class AppToasts {
  static Future<bool?> errorToast(String msg) {
    try {
      copyToClipboard(msg);
    } catch (e) {
      Logger logger = Logger();
      logger.d(e);
    }
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: darkColor,
        textColor: lightColor,
        fontSize: 16);
  }

  static Future<bool?> successToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: lightColor,
        textColor: Colors.black,
        fontSize: 16);
  }
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
