import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/widgets/widgets.dart';

class BookCard extends StatelessWidget {
  String? img;
  String? bookName;
  String? mentor;
  String? price;
  BookCard(
      {Key? key,
      required this.bookName,
      required this.img,
      required this.mentor,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(26, 0, 0, 0),
                blurRadius: 60,
                spreadRadius: 0)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            img!,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.4,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
            child: Text(
              bookName!,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
            child: Text(
              mentor!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: Text(
              '₸${MoneyFormat.get(
                price!,
              )}',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
