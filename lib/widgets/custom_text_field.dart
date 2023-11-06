import 'package:flutter/material.dart';

import '../util/theme.dart';

class CustomTextField extends StatelessWidget {
  //final String title;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? ontap;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextField({
    Key? key,
    //  required this.title,
    this.ontap,
    this.hintText,
    this.hintStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF697D95),
      fontFamily: 'Circular Std',
    ),
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.readOnly = false,
    this.textInputStyle,
    this.onFieldSubmitted
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*    Text(
          title,
          style:  TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Circular Std',
            fontStyle: FontStyle.normal,
            color: ThemeProvider.secondary
          ),
        ),*/
        const SizedBox(height: 20),
        TextFormField(
          cursorColor: ThemeProvider.persianGreen,
          onFieldSubmitted: onFieldSubmitted,
          textAlignVertical: TextAlignVertical.center,
          onTap: ontap,
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          style: textInputStyle,
          decoration: InputDecoration(
            filled: true,
            fillColor: ThemeProvider.whiteColor,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,

            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ThemeProvider.borderColor,
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeProvider.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            hintText: hintText,
            hintStyle: hintStyle,

          ),
        ),
      ],
    );
  }
}
