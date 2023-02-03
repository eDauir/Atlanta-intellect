import 'package:barber/api/MyCourse/IMyCourse.dart';
import 'package:barber/pages/Profile/account/widgets/Policy.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/inputWidget.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SupportPage extends StatefulWidget {
  SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with TickerProviderStateMixin {
  late TabController _courseTabController;

  int totalPages = 0;
  List<ProductsCourse> passedLesson = [];
  List<ProductsCourse> workingLesson = [];

  bool isLoad = false;

  @override
  void initState() {
    super.initState();

    TabController _courseTabController = TabController(length: 2, vsync: this);
  }

  TabBar get _courseTabBar => TabBar(
        tabs: [
          Tab(
            text: 'FAQ',
          ),
          Tab(text: 'Свяжитесь с нами')
        ],
        unselectedLabelColor: greyColor,
        unselectedLabelStyle: headLine4Reg,
        labelColor: primary_color,
        labelStyle: Theme.of(context).textTheme.headline4,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: primary_color, width: 3))),
        indicatorSize: TabBarIndicatorSize.tab,
      );

  @override
  Widget build(BuildContext context) {
    if (isLoad == true) {
      return Scaffold(
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator())));
    }
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/img/arrowBack.svg'),
              ),
              title: Text(
                'Служба поддержки',
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline2,
              ),
              bottom: PreferredSize(
                preferredSize: _courseTabBar.preferredSize,
                child: ColoredBox(
                    color: Theme.of(context).cardColor, child: _courseTabBar),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(
                  top: marginScaleWC(30), bottom: marginScaleWC(20)),
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: FAQ(),
                  ),
                  SingleChildScrollView(child: FollowUs())
                ],
              ),
            )),
      ),
    );
  }
}

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...context.read<GlobalData>().faq[0].faq!.map(
          (e) {
            return buildExpansion(context, e.question, e.answer);
          },
        )
      ],
    );
  }

  Container buildExpansion(BuildContext context, title, text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        backgroundColor: colorWhite,
        tilePadding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
        childrenPadding:
            EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        title: Text(
          title,
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline4,
        ),
        children: [
          Text(
            text,
            textScaleFactor: textScale(context),
            style: headLine5Med,
          )
        ],
      ),
    );
  }
}

class FollowUs extends StatefulWidget {
  @override
  State<FollowUs> createState() => _FollowUsState();
}

class _FollowUsState extends State<FollowUs> {
  TextEditingController emailcon = new TextEditingController();
  TextEditingController question = new TextEditingController();

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: marginScale(context, 10),
          ),
          InputWidget(
            controller: emailcon,
            hintText: 'email-адрес',
          ),
          SizedBox(
            height: marginScale(context, 20),
          ),
          Text(
            'Вопрос',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: marginScale(context, 10),
          ),
          InputWidget(
            controller: question,
            hintText: 'Введите текст',
            maxLines: 5,
            borderRadius: 10,
          ),
          sizeHeight(15),
          CheckboxListTile(
            contentPadding: EdgeInsets.only(left: 0),
            title: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text:
                    'Присылайте мне обновления о продуктах и услугах e-club. ',
                style: headLine5Reg.copyWith(
                  color: greyColor,
                  fontFamily: 'MontserratAlternates',
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Политика конфиденциальности.',
                      style: TextStyle(color: primary_color),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Privacy()))),
                ],
              ),
            ),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue ?? false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          SizedBox(
            height: marginScale(context, 25),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Отправить'))
        ],
      ),
    );
  }
}
