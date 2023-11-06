import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/onboard_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  // declare and initizlize the page controller
  final PageController _pageController = PageController(initialPage: 0);

  // the index of the current page
  int _activePage = 0;

  final List<Widget> _pages = [
    Pages(index: 1),
    Pages(
      index: 2,
    ),
    Pages(index: 3)
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<onBoardController>(
      builder: (value) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
                child: WillPopScope(
              onWillPop: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                return Future.value(false);
              },
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _activePage = page;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _pages[index % _pages.length];
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          _pages.length,
                          (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                  child: Container(width: 40.0, height: 10.0, decoration: new BoxDecoration(color: _activePage == index ? ThemeProvider.secondaryAppColor : Colors.grey, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                                ),
                              )),
                    ),
                  ),
                ],
              ),
            )));
      },
    );
  }
}

class Pages extends StatelessWidget {
  int index = 0;
  Pages({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<onBoardController>(
      builder: (value) {
        return Padding(
          padding: EdgeInsets.all(Dimens.eighteen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: Image.asset(index == 1
                      ? AssetPath.onbarding_image1
                      : index == 2
                          ? AssetPath.onbarding_image2
                          : AssetPath.onbarding_image3)),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: index == 1
                          ? AppString.bills
                          : index == 2
                              ? AppString.upload_bills
                              : AppString.save_time,
                      fontSize: Dimens.thirtyTwo,
                      color: Colors.black,
                      fontFamily: 'bold',
                    ),
                    SizedBox(height: Dimens.ten),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimens.two, horizontal: Dimens.twenty),
                      child: CommonTextWidget(
                        textAlign: TextAlign.center,
                        heading: index == 1
                            ? AppString.manage_finance
                            : index == 2
                                ? AppString.upload_bills_content
                                : AppString.save_time_content,
                        fontSize: Dimens.twenty,
                        color: Colors.black,
                        fontFamily: 'bold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: Dimens.ten),
                    Padding(
                      padding: EdgeInsets.all(Dimens.twenty),
                      child: SubmitButton(
                        onPressed: () => {value.parser.saveWelcome(), Get.close(0), Get.toNamed(AppRouter.authenticationTypeRoute())},
                        title: AppString.signin,
                      ),
                    ),
                    SizedBox(height: Dimens.ten),
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: AppString.continue_without_signin,
                      fontSize: Dimens.sixteen,
                      color: Colors.black,
                      fontFamily: 'bold',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
