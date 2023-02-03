import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentsList extends StatelessWidget {
  String img;
  String name;
  String spec;
  StudentsList(
      {Key? key, required this.img, required this.name, required this.spec})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundColor: greys,
                    backgroundImage: NetworkImage(img),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textScaleFactor: textScale(context),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        spec,
                        textScaleFactor: textScale(context),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: () {}, icon: SvgPicture.asset('assets/img/group.svg'))
        ],
      ),
    );
  }
}
