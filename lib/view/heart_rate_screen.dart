import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/heart_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';
import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  double screenHeight = 0, screenWidth = 0;
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HeartController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
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
                          width: kIsWeb ? screenWidth * .07 : screenWidth * .1,
                          height: kIsWeb ? screenWidth * .07 : screenWidth * .1,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeProvider.borderColor,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * .02),
                            child: SvgPicture.asset(AssetPath.back_arrow),
                          ),
                        ),
                      ),
                      CommonTextWidget(lineHeight: 1.3, heading: AppString.heart_rate, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * .02),
                          child: SvgPicture.asset(AssetPath.setting, width: screenWidth * .012, color: ThemeProvider.blackColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  /*   Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isBPMEnabled
                            ? dialog = HeartBPMDialog(
                                context: context,
                                showTextValues: true,
                                borderRadius: 10,
                                onRawData: (value) {
                                  setState(() {
                                    if (data.length >= 100) data.removeAt(0);
                                    data.add(value);
                                  });
                                },
                                onBPM: (value) => setState(() {
                                  if (bpmValues.length >= 100) bpmValues.removeAt(0);
                                  bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now()));
                                }),
                              )
                            : const SizedBox(),
                        Center(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.favorite_rounded),
                            label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
                            onPressed: () => setState(() {
                              if (isBPMEnabled) {
                                isBPMEnabled = false;
                                // dialog.
                              } else
                                isBPMEnabled = true;
                            }),
                          ),
                        ),

                        SizedBox(height: screenHeight * .09),


                        CommonTextWidget(
                            lineHeight: 1.3,
                            heading: 'Covering the camera lens with the fingertip enables the camera to measure the subtle changes in skin tone. These are proportional to the changes in the blood flow through the arteries just below the skin of the fingertip. This is in-turn correlated to the heart beats. Hence, the variations in the skin tone can be approximated to the instances of heart beats. Measuring the time differences between the peaks provides Beats per Minute.',
                            fontSize: Dimens.sixteen,
                            color: Colors.black,
                            fontFamily: 'light'),
                      ],
                    ),
                  ),*/
                  Row(
                    children: [
                      Obx(() => Expanded(child: healthCard(title: "Heart rate", image: AssetPath.user, data: value.heartRate.value != "null" ? "${value.heartRate.value} bpm" : "", color: const Color(0xFF8d7ffa)))),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      );
    });
  }

  Widget healthCard({String title = "", String data = "", Color color = Colors.blue, required String image}) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Image.asset(image, width: 70),
          Text(data),
        ],
      ),
    );
  }
}
