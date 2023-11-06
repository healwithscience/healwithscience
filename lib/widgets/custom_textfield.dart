import 'package:flutter/material.dart';

import '../util/dimens.dart';
import '../util/theme.dart';
import 'commontext.dart';

class CustomTextField2 extends StatelessWidget {
  final String hintText;

  final double? lowerSpace;
  final double? upperSpace;
  final TextEditingController? controller;
  final IconData icon;
  final bool isIcon;
  final bool isLabel;
  final bool enable;
  final Color labelColor;
  final Color borderColor;
  final String labelText;
  final bool obscureText;
  final FontWeight? fontWeight;
  final TextInputType? keyboardType;
  final int maxLength;
  var focusNode;

  CustomTextField2({
    Key? key,
    required this.hintText,
    this.lowerSpace = 23,
    this.enable = true,
    this.keyboardType,
    this.upperSpace = 10,
    this.controller,
    this.obscureText = false,
    this.icon = Icons.abc_outlined,
    this.isIcon = false,
    this.isLabel = true,
    this.labelText = '',
    this.focusNode,
    this.fontWeight,
    this.maxLength = 30,
    this.borderColor = Colors.black,
    this.labelColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLabel)
          CommonTextWidget(
            heading: labelText,
            fontSize: Dimens.sixteen,
            color: Colors.black,
            fontFamily: 'bold',
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        SizedBox(
          height: Dimens.five,
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: ThemeProvider.buttonborderColors,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            enabled: enable,
            clipBehavior: Clip.none,
            controller: controller,
            obscureText: obscureText,
            maxLength: maxLength,
            keyboardType: keyboardType,
            focusNode: focusNode,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                counterText: "",
                prefixIcon: Icon(isIcon ? icon : null, color: borderColor, size: isIcon ? 26 : 16),
                prefixIconConstraints: BoxConstraints(maxWidth: 3, minWidth: isIcon ? 45 : 0),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 1),
                ),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFEA1A1A1))),
          ),
        ),
      ],
    );
  }
}
