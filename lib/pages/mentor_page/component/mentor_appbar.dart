import 'package:barber/api/Mentors/IMentorId.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';

class MentorsAppBar extends StatefulWidget {
  IMentorId mentorId;
  MentorsAppBar({Key? key, required this.mentorId}) : super(key: key);

  @override
  State<MentorsAppBar> createState() => _MentorsAppBarState();
}

class _MentorsAppBarState extends State<MentorsAppBar> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20, bottom: marginScale(context, 20)),
                  child: Container(
                    width: marginScale(context, 103),
                    height: marginScale(context, 103),
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: greys,
                        backgroundImage:
                            NetworkImage(widget.mentorId.avatar ?? ''),
                        radius: 110,
                      ),
                    ]),
                  ),
                ),
                Text(
                  widget.mentorId.name ?? '',
                  textScaleFactor: textScale(context),
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: marginScale(context, 12),
                      bottom: marginScale(context, 20)),
                  child: Text(
                    widget.mentorId.job ?? '',
                    textScaleFactor: textScale(context),
                    style: headLine4Reg.copyWith(color: greyColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.mentorId.courseCount ?? '',
                              textScaleFactor: textScale(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: primary_color),
                            ),
                            Text(
                              'Курсов',
                              textScaleFactor: textScale(context),
                              style: headLine5Reg,
                            )
                          ],
                        ),
                        VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Column(
                          children: [
                            Text(
                              widget.mentorId.ordersCount ?? '',
                              textScaleFactor: textScale(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: primary_color),
                            ),
                            Text(
                              'Резидентов',
                              textScaleFactor: textScale(context),
                              style: headLine5Reg,
                            )
                          ],
                        ),
                        // VerticalDivider(
                        //   width: 1,
                        //   thickness: 1,
                        //   color: Theme.of(context).dividerColor,
                        // ),
                        // Column(
                        //   children: [
                        //     Text(
                        //       widget.mentorId.commentsCount ?? '',
                        //       textScaleFactor: textScale(context),
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .headline2!
                        //           .copyWith(color: primary_color),
                        //     ),
                        //     Text(
                        //       'Отзывов',
                        //       textScaleFactor: textScale(context),
                        //       style: headLine4Med,
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container button2(
    BuildContext context,
    String text,
  ) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            text,
            textScaleFactor: textScale(context),
          ),
        ));
  }
}
