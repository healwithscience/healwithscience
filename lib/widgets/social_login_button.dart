// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/app_assets.dart';
import '../util/theme.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final TextStyle style;
  final Color  backgroundColor;
  final String iconPath;
  const SocialLoginButton({Key? key, required this.onPressed, required this.title,required this.style,required this.backgroundColor,required this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.25), offset: Offset(0, 0), blurRadius: 2, spreadRadius: 1)]),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side:BorderSide.none,)),
              backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor,
              )),
          onPressed: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
              ),
              SizedBox(width: 10),
              Text(title,
                  style:style
                  )],
          )),
    );
  }
}