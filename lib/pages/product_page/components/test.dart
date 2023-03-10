import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/api/Product/productApi.dart';
import 'package:barber/pages/product_page/components/class_test.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

PageController controller = PageController();
showTest(context, Function passedLesson, id) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return testWidget(
          passedLesson: passedLesson,
          id: id,
        );
      });
}

class testWidget extends StatefulWidget {
  Function passedLesson;
  String id;
  testWidget({Key? key, required this.passedLesson, required this.id})
      : super(key: key);

  @override
  State<testWidget> createState() => _testWidgetState();
}

class _testWidgetState extends State<testWidget> {
  List<Questions> questions = [];

  List<Answer> answer = [];

  bool isLoad = true;

  bool isClose = true;

  getData() async {
    setState(() {
      isLoad = true;
    });
    List<Questions> data = await getTest(widget.id);
    questions = data ?? [];

    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: ((context, setState) {
      if (isLoad) {
        Dialog(child: CircularProgressIndicator());
      }
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: marginScale(context, 5)),
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: IconButton(
                      splashRadius: 15,
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<Counter>().setReloadValue();
                      },
                      icon: SvgPicture.asset(
                        'assets/img/close-circle.svg',
                        color: greyColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: marginScale(context, 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    context.read<Counter>().counterLengthTest ==
                            questions.length
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ...List.generate(questions.length, (int index) {
                                if (context.read<Counter>().isResult[index]) {
                                  return percent(
                                      context, questions.length, Colors.green);
                                }
                                return percent(
                                    context, questions.length, Colors.red);
                              })
                            ],
                          )
                        : Row(
                            children: [
                              ...List.generate(questions.length, (int index) {
                                if (context.read<Counter>().counterLengthTest >
                                    index) {
                                  return percent(
                                      context, questions.length, primary_color);
                                }
                                return percent(
                                  context,
                                  questions.length,
                                );
                              })
                            ],
                          ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ExpandablePageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  animationDuration: Duration(microseconds: 0),
                  children: [
                    ...questions.asMap().entries.map((e) => test(
                          context: context,
                          setState: setState,
                          quest: e.value.title ?? '',
                          answers: e.value.answer ?? [],
                          pcon: controller,
                          lengh: e.key,
                          value: e.value.answer![0].isTrue ?? '0',
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: marginScale(context, 20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  context.read<Counter>().checkRes()
                                      ? '???? ???????????? ????????'
                                      : '???? ???? ???????????? ????????.\n???????????????????? ?????? ??????!',
                                  style: Theme.of(context).textTheme.headline3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                context.read<Counter>().check(),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: marginScale(context, 40)),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (context.read<Counter>().checkRes()) {
                                        widget.passedLesson();
                                        Navigator.pop(context);
                                        context
                                            .read<Counter>()
                                            .setReloadValue();
                                        return;
                                      }
                                      context.read<Counter>().setReloadValue();
                                      controller.jumpToPage(0);
                                      setState(
                                        () {},
                                      );
                                    },
                                    child: Text(context
                                                .watch<Counter>()
                                                .isShowRemoveBtn ==
                                            false
                                        ? '???????????? ????????????'
                                        : '????????????')),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}

LinearPercentIndicator percent(BuildContext context, num length,
    [Color? color]) {
  return LinearPercentIndicator(
    padding: EdgeInsets.zero,
    animation: true,
    animationDuration: 1000,
    barRadius: Radius.circular(5),
    width: MediaQuery.of(context).size.width * 0.65 / length,
    lineHeight: 10,
    percent: 0,
    backgroundColor: color != null ? color : Colors.grey.withOpacity(0.5),
    trailing: null,
    leading: null,
  );
}

class test extends StatefulWidget {
  test({
    Key? key,
    required this.context,
    required this.setState,
    required this.quest,
    required this.answers,
    required this.pcon,
    required this.lengh,
    required this.value,
  }) : super(key: key);

  final BuildContext context;
  final StateSetter setState;
  final String quest;
  final List<Answer> answers;
  final int lengh;
  String value;
  final PageController pcon;

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  String idRightAnswer = '0';
  String val = '-1';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginScale(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: marginScale(context, 20),
              bottom: marginScale(context, 10),
            ),
            child: Text(
              '???????????? ${widget.lengh + 1}:',
              textScaleFactor: textScale(context),
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            widget.quest,
            textScaleFactor: textScale(context),
            style: headLine5Reg,
          ),
          Container(
            margin: EdgeInsets.only(
              top: marginScaleWC(10),
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(children: [
              ...widget.answers.asMap().entries.map((e) {
                if (e.value.isTrue == '1') {
                  idRightAnswer = e.key.toString();
                }
                return showAnser(context, e.value.title ?? '', e.key.toString(),
                    e.key == widget.answers.length - 1);
              }),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: marginScaleWC(20)),
            child: ElevatedButton(
                onPressed: () {
                  if (val == '-1') return;
                  widget.setState(
                    () {
                      context.read<Counter>().setCounter();
                      context.read<Counter>().setIsResult(idRightAnswer == val);

                      widget.pcon.nextPage(
                          duration: Duration(milliseconds: 10),
                          curve: Curves.linear);
                    },
                  );
                },
                child: Text('??????????????????')),
          )
        ],
      ),
    );
  }

  showAnser(BuildContext context, title, valueAnswer, [bool isLast = false]) {
    selectAnswer(value) {
      setState(() {
        val = value;
      });
    }

    return GestureDetector(
      onTap: () => {selectAnswer(valueAnswer)},
      child: Padding(
        padding: EdgeInsets.symmetric(
                vertical: marginScaleWC(10), horizontal: marginScaleWC(15))
            .copyWith(bottom: 0),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  // splashRadius: 0,
                  value: valueAnswer,
                  groupValue: val,
                  fillColor: MaterialStateProperty.all(primary_color),
                  onChanged: (value) {
                    selectAnswer(value);
                  },
                ),
                sizeWidth(10),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 3,
                    style: headLine5Reg,
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: marginScaleWC(12)),
              width: double.infinity,
              height: isLast ? 0 : 1,
              color: greyColor,
            )
          ],
        ),
      ),
    );
  }
}
