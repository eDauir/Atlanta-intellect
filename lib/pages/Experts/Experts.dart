import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Experts extends StatefulWidget {
  String? searchKey;

  Experts({super.key , this.searchKey});

  @override
  State<Experts> createState() => _ExpertsState();
}

class _ExpertsState extends State<Experts> {
  List<Workers>? expertsArray = [];

  getExpertsWrap() async {
    List<IMentor>? data = await getMentors(searchKey : widget.searchKey ?? '');
    if (data == null) return;

    expertsArray = data[0].workers;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getExpertsWrap();
  }

  final myController = TextEditingController();

  onSubmit(String value) async {
    var res = await getMentors( searchKey : 'Admin');
    expertsArray = res;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(maxWidth: 600),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            if (expertsArray == null)
              CircularProgressIndicator()
            else if (expertsArray!.length == 0)
              Text(
                'Не найдено ',
                textScaleFactor: textScale(context),
              ),
            if (expertsArray!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    // ...expertsArray!.map((e) {
                    //   return ItemExpert(item: e);
                    // })
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  


}


Container ItemExpert({required String ? avater , name , job , required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(bottom: marginScale(context, 20)),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: avater ?? '',

            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: greys,
              backgroundImage: imageProvider,
              maxRadius: marginScale(context, 30),
            ),
            placeholder: (context, url) => Center(
                                child: Container(
                                    width: marginScale(context, 15),
                                    height: marginScale(context, 15),
                                    child: CircularProgressIndicator())),
          ),
          SizedBox(
            width: marginScale(context, 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               name?? '',
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: marginScale(context, 7),
              ),
              Text(
               job ?? '',
                textScaleFactor: textScale(context),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: greys.withOpacity(1)),
              )
            ],
          )
        ],
      ),
    );
  }