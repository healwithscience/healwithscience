import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heal_with_science/controller/subscription_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import 'package:heal_with_science/widgets/common_card.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<SubscriptionController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: WillPopScope(
            onWillPop: () async {
              value.onBackRoutes(); // Call your function
              return false; // Return true to allow back navigation, or false to prevent it.
            },
            child: Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          value.onBackRoutes();
                        },
                        child: Container(
                          width: screenWidth * .1,
                          height: screenWidth * .1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeProvider.borderColor,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * .02),
                            child: SvgPicture.asset(AssetPath.back_arrow),
                          ),
                        ),
                      ),
                      CommonTextWidget(
                        heading: AppString.choose_plan,
                        fontSize: Dimens.twentyFour,
                        color: Colors.black,
                        fontFamily: 'bold',
                      ),
                      SizedBox(
                        width: screenWidth * .02,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(onTap: () {

                        }, child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.free_plan, point1: AppString.free_plan_point1, point2: AppString.free_plan_point2, point3: AppString.free_plan_point3, imagePath: AssetPath.free_plan)),
                        InkWell(
                            onTap: () {
                              value.purchaseProduct("intermediate_plan");
                            },
                            child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.paid_plan, point1: AppString.paid_plan_point1, point2: "", point3: AppString.paid_plan_point2, imagePath: AssetPath.pain_plan)),
                        InkWell(
                            onTap: () {
                              value.purchaseProduct("advanced_plan");
                            },
                            child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.featured_plan, point1: AppString.featured_plan_point1, point2: AppString.featured_plan_point2, point3: AppString.featured_plan_point3, imagePath: AssetPath.featured_plan)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
