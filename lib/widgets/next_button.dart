import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/theme.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double width;
  final double height;

  const NextButton({Key? key, required this.onPressed, required this.title ,required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  width: MediaQuery.of(context).size.width,
     width: width,
      height: height,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
            color: Colors.white.withOpacity(0.25),
            offset: Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 1)
      ]),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none)),
              backgroundColor: MaterialStateProperty.all<Color>(
                ThemeProvider.secondaryAppColor,
              )),
          onPressed: onPressed,
          child: Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ))),
    );
  }
}
