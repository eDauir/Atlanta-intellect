import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/api/Product/productApi.dart';
import 'package:barber/pages/product_page/components/test.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/Video.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductLessons extends StatefulWidget {
  List<Sections> section;
  int lessonCount;
  List myProgress;
  List<IProductProgress> myProgressFinish;
  bool isPassedCourse;
  Function changePassedCourse;
  bool isBuy;

  ProductLessons(
      {Key? key,
      required this.section,
      required this.lessonCount,
      required this.myProgress,
      required this.myProgressFinish,
      required this.isPassedCourse,
      required this.isBuy,
      required this.changePassedCourse})
      : super(key: key);

  @override
  State<ProductLessons> createState() => _ProductLessonsState();
}

class _ProductLessonsState extends State<ProductLessons> {
  bool isLoad = true;

  int sectionCount = 1;
// нумерация уроков
  int checkLessonCount = 1;

  // true = Open lesson
  int countLessonOpen = 0;

  bool passedLesson = true;

  String login = '';

  checkPassedLesson(String lessonId) {
    // не купил
    if (widget.myProgress.isEmpty || widget.isBuy == false) return false;

    for (int i = 0; i < widget.myProgress.length; i++) {
      if (widget.myProgress[i]['lessonId'] == lessonId) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    countLessonOpen = 0;
  }

  @override
  Widget build(BuildContext context) {
    login = context.read<GlobalData>().loginToken ?? '';

    checkLessonCount = 1;

    countLessonOpen = 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.symmetric(
                horizontal: marginScale(context, 15), vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.lessonCount} Уроков',
                  style: Theme.of(context).textTheme.headline3,
                  textScaleFactor: textScale(context),
                ),
              ],
            ),
          ),
          ...widget.section.asMap().entries.map((e) {
            if (e.value.lessons == null) {
              return SizedBox();
            }
            return itemSection(context, e.value, sectionCount++);
          }),
          if (widget.isPassedCourse)
            Container(
              margin: EdgeInsets.only(top: marginScale(context, 25)),
              padding:
                  EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
              child: ElevatedButton(
                  onPressed: () async {
                    checkLessonCount = 1;
                    countLessonOpen = 0;
                    await showFeedBackWindow(context,
                        productId: widget.section[0].productId!);
                    // widget.changePassedCourse();
                  },
                  child: Text('Оставить отзыв')),
            ),
          SizedBox(
            height: marginScale(context, 70),
          )
        ],
      ),
    );
  }

  Container itemSection(
      BuildContext context, Sections sections, int countSection) {
    return Container(
      color: homeBg,
      margin: EdgeInsets.only(top: marginScale(context, 20)),
      padding: EdgeInsets.symmetric(
        horizontal: marginScale(context, 15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Секция ${countSection} - ${sections.name}',
                textScaleFactor: textScale(context),
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: greyColor),
              ),
            ],
          ),
          if (sections.lessons != null)
            ...sections.lessons!.asMap().entries.map((e) {
              bool curPassed = checkPassedLesson(e.value.id!);

              return _lesson(
                  context: context,
                  name: e.value.name ?? '',
                  min: int.parse(e.value.elemDuration ?? '0'),
                  keys: checkLessonCount++,
                  link: e.value.elemLink,
                  elemType: e.value.elemType ?? '0',
                  lessonId: e.value.id ?? '0',
                  productId: e.value.productId!,
                  passedLesson: curPassed,
                  loginToken: login);
            }),
        ],
      ),
    );
  }

  _lesson(
      {required BuildContext context,
      required String name,
      required int min,
      required int keys,
      String? link,
      required String elemType,
      required String lessonId,
      required String productId,
      required bool passedLesson,
      required String loginToken}) {
    bool isLock = true;

    if (widget.isBuy == false) {
      isLock = true;
    } else {
      isLock = false;
    }

    return Padding(
      padding: EdgeInsets.only(top: marginScale(context, 15)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: marginScale(context, 50),
                  height: marginScale(context, 50),
                  decoration: BoxDecoration(
                      color: passedLesson
                          ? Colors.green.withOpacity(0.1)
                          : bgPrimaryColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(marginScale(context, 15)))),
                  child: Center(
                    child: Text(keys.toString(),
                        textScaleFactor: textScale(context),
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color:
                                  passedLesson ? Colors.green : primary_color,
                            )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: marginScale(context, 15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: marginScale(context, 160),
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: marginScale(context, 8)),
                          child: Text(
                            name,
                            textScaleFactor: textScale(context),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      if (elemType == '1')
                        Text(
                          '${min.toString()} min ',
                          textScaleFactor: textScale(context),
                          style: headLine5Med.copyWith(color: Colors.grey),
                        )
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
                splashRadius: 15,
                onPressed: () async {
                  if (isLock == true || loginToken.isEmpty) return;

                  handlerPassedLesson() async {
                    if (loginToken.isNotEmpty && passedLesson == false) {
                      await setProgressProduct(productId, loginToken, lessonId);

                      await setProgressProductFinish(
                          productId, lessonId, loginToken);

                      widget.myProgress.add({'lessonId': '${lessonId}'});

                      setState(() {
                        passedLesson = true;
                        countLessonOpen = 0;
                        checkLessonCount = 1;
                        if (widget.myProgress.length == widget.lessonCount) {
                          widget.changePassedCourse();
                          widget.isPassedCourse = true;
                        }
                      });
                    }
                  }

                  if (elemType == '1') {
                    await handlerPassedLesson();
                  }

                  // print(nextLessonId == null ? 'WHAT' : nextLessonId);

                  if (elemType == '0')
                    showTest(context, handlerPassedLesson, link);

                  if (elemType == '1')
                    return showDialog(
                      context: context,
                      builder: (context) => WillPopScope(
                        onWillPop: () async {
                          setState(() {
                            countLessonOpen = 0;
                            checkLessonCount = 1;
                          });
                          Navigator.pop(context);
                          return false;
                        },
                        child: Dialog(
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.black,
                          child: Stack(
                            children: [
                              if (link != null) VideoWidget(link: link),
                              Positioned(
                                top: marginScale(context, 50),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: 10,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                },
                icon: isLock
                    ? SvgPicture.asset('assets/img/ProductUnlock.svg')
                    : elemType == '1'
                        ? SvgPicture.asset(
                            'assets/img/video.svg',
                            color: passedLesson ? Colors.green : null,
                          )
                        : SvgPicture.asset(
                            'assets/img/test.svg',
                            color: passedLesson ? Colors.green : null,
                          ))
          ],
        ),
      ),
    );
  }
}
