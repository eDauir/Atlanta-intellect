import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/pages/Experts/Experts.dart';
import 'package:barber/pages/mentor_page/mentor.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ProductMentors extends StatelessWidget {
  UserInfo mentor;
  String mentorId;
  String productInfo;
  ProductMentors(
      {Key? key,
      required this.mentor,
      required this.mentorId,
      required this.productInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: marginScale(context, 15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: marginScale(context, 30),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Mentor(
                                id: mentorId,
                              )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemExpert(
                        name: mentor.name,
                        avater: mentor.avatar,
                        job: mentor.job,
                        context: context),
                    Container(
                        margin:
                            EdgeInsets.only(bottom: marginScale(context, 20)),
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
            ),
            Text(
              'О курсе',
              textScaleFactor: textScale(context),
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: marginScale(context, 15),
            ),
            ReadMoreText(productInfo,
                textScaleFactor: textScale(context),
                trimLines: 5,
                trimCollapsedText: ' Читать еще...',
                colorClickableText: primary_color,
                trimExpandedText: ' Читать меньше',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: HexColor('#808080'), fontWeight: FontWeight.w400)),
            SizedBox(
              height: marginScale(context, 74),
            ),
          ],
        ),
      ),
    );
  }
}
