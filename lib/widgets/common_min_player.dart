import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:heal_with_science/widgets/round_button.dart';

import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/theme.dart';
import 'commontext.dart';

class CustomMiniPlayer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const CustomMiniPlayer({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.08,
      color: ThemeProvider.blackColor, // Set the color as needed
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(AssetPath.mini_player),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CommonTextWidget(
                        heading: StaticValue.frequencyName.value,
                        fontSize: Dimens.thrteen,
                        color: Colors.white,
                        fontFamily: 'light')),
                    SizedBox(height: 8),
                    Obx(() => CommonTextWidget(
                        heading: StaticValue.frequencyValue.value.toString(),
                        fontSize: Dimens.thrteen,
                        color: Colors.white,
                        fontFamily: 'regular')),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (StaticValue.isPlaying.value == false) {
                  StaticValue.startTime();
                  StaticValue.playFrequency();
                } else {
                  StaticValue.pauseTimer();
                  StaticValue.stopFrequency();
                }
              },
              child: Obx(() => RoundButton(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                borderColor: ThemeProvider.borderColor,
                padding: screenWidth * 0.03,
                background: ThemeProvider.bright_gray,
                child: StaticValue.isPlaying.value
                    ? SvgPicture.asset(AssetPath.play2)
                    : SvgPicture.asset(AssetPath.play),
              )),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                print("HelloHereTimer" +
                    StaticValue.frequenciesList.length.toString());
                StaticValue.miniPlayer.value = false;
                StaticValue.resetTimer();
              },
            ),
          ],
        ),
      ),
    );
  }
}
