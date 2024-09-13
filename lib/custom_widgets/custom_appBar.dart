import 'package:flutter/material.dart';

import '../constants.dart';

PreferredSizeWidget customAppBar({required String text}) {
  return AppBar(
    toolbarHeight: 65,
    centerTitle: true,
    backgroundColor: lightColor,
    iconTheme: const IconThemeData(color: darkColor), // Setting the icon color
    title: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 15,
        ),
        Image.asset(
          'assets/images/icon.png',
          height: 25,
          width: 60,
        ),
        FittedBox(
          child: Text(
            text,
            style: const TextStyle(color: darkColor),
          ),
        ),
      ],
    ),
  );
}
