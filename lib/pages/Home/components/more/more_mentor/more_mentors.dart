import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/pages/Experts/Experts.dart';
import 'package:barber/pages/mentor_page/mentor.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MoreMentors extends StatefulWidget {
  MoreMentors({Key? key}) : super(key: key);

  @override
  State<MoreMentors> createState() => _MoreMentorsState();
}

class _MoreMentorsState extends State<MoreMentors> {
  int currentPage = 1;
  int totalPage = 1;

  bool isLoad = false;

  List<Workers> mentors = [];

  getData({required String page, String searchKey = ''}) async {
    setState(() {
      isLoad = true;
    });

    List<IMentor>? data = await getMentors(
      page: page,
    );

    currentPage = int.parse(page);
    totalPage = data![0].count ?? 1;

    print(totalPage);
    print(currentPage);

    mentors.addAll(data[0].workers ?? []);
    // context.read<GlobalData>().addMore(data[0].products ?? []);

    isLoad = false;
    setState(() {});
  }

  initData() async {
    setState(() {
      isLoad = true;
    });

    mentors = context.read<GlobalData>().mentors;

    currentPage = 1;
    totalPage = context.read<GlobalData>().mentorsTotalPage;

    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/img/arrowBack.svg')),
          title: Text(
            'Все эксперты',
            style: Theme.of(context).textTheme.headline2,
            textScaleFactor: textScale(context),
          )),
      body: isLoad
          ? Center(
              child: SingleChildScrollView(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      ...mentors.map((e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mentor(
                                            id: e.userId!,
                                          )));
                            },
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mentor(
                                              id: e.userId ?? '',
                                            )));
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: ItemExpert(
                                  name: e.name,
                                  avater: e.avatar,
                                  job: e.job,
                                  context: context),
                            ),
                          )),
                      SizedBox(
                        height: marginScale(context, 15),
                      ),
                      if (totalPage > 1 && totalPage >= currentPage)
                        btnMore(context, getData, currentPage),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
