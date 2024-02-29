import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/heart_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  double screenHeight = 0,
      screenWidth = 0;

  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HeartController>(builder: (value) {
       return Scaffold(
         backgroundColor: Colors.grey.shade100,
         appBar: AppBar(
           backgroundColor: Colors.white,
           title: Text('Heart BPM Demo'),
         ),
         body: Column(
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
                 // chart = BPMChart(data);
               },
               onBPM: (value) =>
                   setState(() {
                     if (bpmValues.length >= 100) bpmValues.removeAt(0);
                     bpmValues.add(SensorValue(
                         value: value.toDouble(), time: DateTime.now()));
                   }),
               // sampleDelay: 1000 ~/ 20,
               // child: Container(
               //   height: 50,
               //   width: 100,
               //   child: BPMChart(data),
               // ),
             )
                 : SizedBox(),
             isBPMEnabled && data.isNotEmpty
                 ? Container(
               decoration: BoxDecoration(border: Border.all()),
               height: 180,
               child: BPMChart(data),
             )
                 : SizedBox(),
             isBPMEnabled && bpmValues.isNotEmpty
                 ? Container(
               decoration: BoxDecoration(border: Border.all()),
               constraints: BoxConstraints.expand(height: 180),
               child: BPMChart(bpmValues),
             )
                 : SizedBox(),
             Center(
               child: ElevatedButton.icon(
                 icon: Icon(Icons.favorite_rounded),
                 label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
                 onPressed: () =>
                     setState(() {
                       if (isBPMEnabled) {
                         isBPMEnabled = false;
                         // dialog.
                       } else
                         isBPMEnabled = true;
                     }),
               ),
             ),
           ],
         ),
       );
    });
  }


/*  @override
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
                      CommonTextWidget(lineHeight: 1.3,
                          heading: AppString.heart_rate,
                          fontSize: Dimens.twentyFour,
                          color: Colors.black,
                          fontFamily: 'bold'),
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
                  Container(
                    height: screenHeight * .7,
                    alignment: Alignment.center,
                    child: Center(
                      child: CommonTextWidget(
                          heading: AppString.comingSoon,
                          fontSize: Dimens.sixteen,
                          color: Colors.black,
                          fontFamily: 'regular'),
                    ),
                  )

                ],
              )),
        ),
      );
    });
  }*/


}





/*
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
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight * .7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => value.loading.value == '1'
                              ? CircularProgressIndicator(color: ThemeProvider.primary)
                              : value.loading.value == '2'
                                  ? CommonTextWidget(textAlign: TextAlign.center, heading: 'Your should wear smart watch and it should be connect with google fit account for results.', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular')
                                  : Column(
                                      children: [
                                        SvgPicture.asset(AssetPath.heart,width: screenWidth * .3,height: screenWidth * .3),
                                        SizedBox(height: screenHeight * .03),
                                        InkWell(
                                            onTap: (){
                                              value.goToNext(double.parse(value.rmssd.value.toStringAsFixed(2)));
                                            },
                                            child: CommonTextWidget(heading: value.rmssd.value.toStringAsFixed(2), fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')),
                                        SizedBox(height: 10),
                                        CommonTextWidget(heading: 'Heart rate variability (HRV)', fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')
                                      ],
                                    ),
                        )

                        // Obx(() => Expanded(child: healthCard(title: "Heart rate", image: AssetPath.user, data: value.heartRate.value != "null" ? "${value.heartRate.value} bpm" : "", color: const Color(0xFF8d7ffa)))),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                      ],
                    ),
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
*/
