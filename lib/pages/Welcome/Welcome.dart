import 'package:barber/pages/Welcome/item.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int activeIndex = 0;

  CarouselController buttonCarouselController = CarouselController();

  List imgList = [Text('awdwa'), Text('Hello')];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: marginScaleWC(15), right: marginScaleWC(15), top: MediaQuery.of(context).padding.top),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  reverse: false,
                  enableInfiniteScroll: false,
                  // aspectRatio:  (widget.isDevice == DeviceScreenType.mobile) ? 1.5 : 4.5,
                  height: MediaQuery.of(context).size.height * 0.7,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) =>
                      {setState(() => activeIndex = index)}),
              items: items.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            i['image'],
                            width: marginScale(context, 250),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            i['description'],
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                buildIndicator(),
                Container(
                  margin: EdgeInsets.only(top: marginScaleWC(20), bottom: marginScaleWC(40)),
                  child: ElevatedButton(
                      onPressed: () {
                        if (activeIndex == items.length - 1) {
                          context.go('/auth');
                        }
                        buttonCarouselController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      child: Container(
                          width: double.infinity,
                          child: Center(child: Text('Продолжить')))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: items.length,

        // effect: WormEffect(),
        effect: ExpandingDotsEffect(
            dotWidth: 10,
            dotHeight: 10,
            dotColor: Colors.grey,
            activeDotColor: primary_dark),
      );
}
