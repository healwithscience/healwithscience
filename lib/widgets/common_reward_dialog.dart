import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import 'commontext.dart';

void showCommonRewardDialog(BuildContext context,double screenHeight,double screenWidth,Function onAction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Flexible(
          child: SizedBox(
            height: screenHeight * 0.2,
            child: Column(
              children: [
                CommonTextWidget(
                  heading: AppString.reward_Point,
                  fontSize: Dimens.twentyFour,
                  color: Colors.black,
                  fontFamily: 'bold',
                ),
                SizedBox(height: screenHeight * 0.02),
                CommonTextWidget(
                  heading: AppString.no_points,
                  fontSize: Dimens.forteen,
                  color: Colors.black,
                  fontFamily: 'medium',
                ),
                SizedBox(height: screenHeight * 0.01),
                CommonTextWidget(
                  heading: AppString.earn_more,
                  fontSize: Dimens.forteen,
                  color: Colors.black,
                  fontFamily: 'medium',
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: screenWidth * 0.2,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.cancel,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        onAction();   SizedBox(height: screenHeight * 0.4);
                      },
                      child: SizedBox(
                        width: screenWidth * 0.2,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.warch_ad,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
