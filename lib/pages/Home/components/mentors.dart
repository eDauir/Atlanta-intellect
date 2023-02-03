import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/generated/locale_keys.g.dart';
import 'package:barber/pages/Home/components/more/more_mentor/more_mentors.dart';
import 'package:barber/pages/mentor_page/mentor.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Mentors extends StatefulWidget {
  @override
  State<Mentors> createState() => _MentorsState();
}

class _MentorsState extends State<Mentors> {
  List<Workers> mentors = [];

  getData() async {
    List<IMentor>? data = await getMentors();

    if (data == null) return;

    setState(() {
      mentors = data[0].workers ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    mentors = context.read<GlobalData>().mentors;

    List items = List<Widget>.generate(
      mentors.length,
      (i) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Mentor(
                        id: mentors[i].userId ?? '',
                      )));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: marginScale(context, 7.5)),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: mentors[i].avatar ?? 'http://picsum.photos/200/300',
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundColor: greys,
                  backgroundImage: imageProvider,
                  maxRadius: marginScale(context, 30),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
              SizedBox(
                height: marginScale(context, 6),
              ),
              Text(
                mentors[i].name ?? '',
                style: headLine5Med,
                textScaleFactor: textScale(context),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.our_mentors.tr(),
              textScaleFactor: textScale(context),
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => MoreMentors())));
                  //context.go('/search', extra: {'index': 1});
                }, 
                child: Text(
                  LocaleKeys.all.tr(),
                  textScaleFactor: textScale(context),
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: primary_color),
                ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: marginScale(context, 100),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [...items.map((e) => e)],
          ),
        ),
      ],
    );
  }
}
