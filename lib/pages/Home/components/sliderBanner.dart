import 'package:barber/api/Banner/IBanner.dart';
import 'package:barber/api/Banner/bannerApi.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({
    Key? key,
  }) : super(key: key);
  @override
  State<SliderBanner> createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  // bool isLoad = true;
  List<IBanner> imgList = [];
  getImages() async {
    imgList = await getBanner();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // getImages();
  }

  int activeIndex = 0;

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    imgList = context.read<GlobalData>().bannerList ?? [];
    // if (isLoad) {
    //   return Container(
    //       margin: EdgeInsets.symmetric(vertical: 10),
    //       child: CircularProgressIndicator());
    // }
    if (imgList.isEmpty) {
      return SizedBox();
    }
    return Container(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                    height: marginScale(context, 138),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) =>
                        {setState(() => activeIndex = index)}),
                items: imgList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        constraints: BoxConstraints(maxWidth: double.infinity),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: CachedNetworkImage(
                            imageUrl: i.link ?? '',
                            imageBuilder: (context, imageProvider) => Image(
                              width: double.infinity,
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            placeholder: (context, url) => Center(
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator())),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned.fill(
              bottom: marginScale(context, 10),
              child: Align(
                  alignment: Alignment.bottomCenter, child: buildIndicator())),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: imgList.length,

        // effect: WormEffect(),
        effect: ExpandingDotsEffect(
            dotWidth: marginScale(context, 4),
            dotHeight: marginScale(context, 4),
            dotColor: Colors.grey,
            activeDotColor: Colors.white),
      );
}
