import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/add_payment_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_textfield.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<AddPaymentController>(builder: (value) {
      return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: WillPopScope(
          onWillPop: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(false);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              ClipOval(
                child: Material(
                  color: Colors.grey.withOpacity(0.2), // Button color
                  child: InkWell(
                    onTap: () {
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    child: SizedBox(width: Dimens.forty, height: Dimens.forty, child: Icon(Icons.arrow_back_outlined)),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Center(
                  child: CommonTextWidget(
                heading: AppString.add_payment_method,
                fontSize: Dimens.thirty,
                color: Colors.black,
                fontFamily: 'bold',
                fontWeight: FontWeight.w600,
              )),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              // CommonTextWidget(
              //   heading: AppString.card_number,
              //   fontSize: Dimens.sixteen,
              //   color: Colors.black,
              //   fontFamily: 'bold',
              //   fontWeight: FontWeight.w500,
              // ),
              // SizedBox(
              //   height: screenHeight * 0.02,
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommonTextWidget(
                    heading: AppString.card_number,
                    fontSize: Dimens.sixteen,
                    color: Colors.black,
                    fontFamily: 'bold',
                    fontWeight: FontWeight.w400,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       AppString.scan_card,
                  //       style: TextStyle(fontFamily: 'bold', fontWeight: FontWeight.w400, fontSize: Dimens.sixteen, decoration: TextDecoration.underline, color: ThemeProvider.secondaryAppColor),
                  //     ),
                  //     Icon(
                  //       Icons.linked_camera_outlined,
                  //       size: Dimens.forteen,
                  //       color: ThemeProvider.buttonColors,
                  //     )
                  //   ],
                  // )
                ],
              ),
              CustomTextField2(
                isLabel: false,
              //  controller: value.mobileNumberController,
                labelText: AppString.card_number,
                hintText: "",
                upperSpace: 0,
                borderColor: ThemeProvider.buttonborderColors,
                keyboardType: TextInputType.number,
              ), // CustomTextField(
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomTextField2(
                isLabel: true,
               // controller: value.mobileNumberController,
                labelText: AppString.card_holder_name,
                hintText: "",
                fontWeight: FontWeight.w400,
                upperSpace: 0,
                borderColor: ThemeProvider.buttonborderColors,
                keyboardType: TextInputType.number,
              ), // CustomTextField(
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomTextField2(
                isLabel: true,
             //   controller: value.mobileNumberController,
                labelText: AppString.expire_date,
                hintText: "",
                fontWeight: FontWeight.w400,
                upperSpace: 0,
                borderColor: ThemeProvider.buttonborderColors,
                keyboardType: TextInputType.number,
              ), // CustomTextField(
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomTextField2(
                isLabel: true,
              //  controller: value.mobileNumberController,
                labelText: AppString.cvc,
                hintText: "",
                fontWeight: FontWeight.w400,
                upperSpace: 0,
                borderColor: ThemeProvider.buttonborderColors,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              CustomTextField2(
                isLabel: true,
             //   controller: value.mobileNumberController,
                labelText: AppString.billing_address,
                hintText: "",
                fontWeight: FontWeight.w400,
                upperSpace: 0,
                borderColor: ThemeProvider.buttonborderColors,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SubmitButton(
                onPressed: () => {value.onPaymentScreenClicked()},
                title: AppString.confirm,
              )
            ],
          ),
        ),
      ))));
    });
  }
}
