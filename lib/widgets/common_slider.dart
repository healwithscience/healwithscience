import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heal_with_science/widgets/round_button.dart';

import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import 'commontext.dart';

class CommonSliderWidget extends StatelessWidget {
  final double value;
  final Function(double) onChanged;
  final double buttonSize;
  final String title;
  final String sliderValue;
  final Function() onPlus;
  final Function() onMinus;
  final double maxSliderValue;
  final double minSliderValue;
  final Color textColor;
  final Color buttonColor;


  CommonSliderWidget({
    required this.value,
    required this.onChanged,
    required this.buttonSize,
    required this.title,
    this.sliderValue = "0",
    required this.onPlus,
    required this.onMinus,
    required this.maxSliderValue,
    required this.minSliderValue,
    this.textColor = ThemeProvider.whiteColor,
    this.buttonColor = ThemeProvider.whiteColor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                lineHeight: 1.3,
                heading: title,
                fontSize: Dimens.thrteen,
                color:textColor,
                fontFamily: 'regular',
              ),
              Row(
                children: [
                  // Minus Button
                  InkWell(
                    onTap: onMinus,
                    child: RoundButton(
                      width: buttonSize,
                      height: buttonSize,
                      child: SvgPicture.asset(AssetPath.minus),
                      background: buttonColor,
                      borderColor: ThemeProvider.borderColor,
                      padding: 4,
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: CommonTextWidget(
                      lineHeight: 1.3,
                      heading: sliderValue,
                      fontSize: Dimens.thrteen,
                      color: textColor,
                      fontFamily: 'regular',
                    ),
                  ),
                  // Plus Button
                  InkWell(
                    onTap:onPlus,
                    child: RoundButton(
                      width: buttonSize,
                      height: buttonSize,
                      child: SvgPicture.asset(AssetPath.plus, color: Colors.white),
                      background:buttonColor,
                      borderColor: ThemeProvider.borderColor,
                      padding: 4,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Slider(
          activeColor: ThemeProvider.persianGreen,
          inactiveColor: ThemeProvider.borderColor,
          value: value,
          onChanged: onChanged,
          min: minSliderValue,
          max: maxSliderValue,
        ),
      ],
    );
  }
}
