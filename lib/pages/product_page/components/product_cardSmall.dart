import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';

class ProductSmallCards extends StatefulWidget {
  String img = '';
  String name = '';
  String price = '';
  ProductSmallCards(
      {Key? key, required this.img, required this.name, required this.price})
      : super(key: key);

  @override
  State<ProductSmallCards> createState() => _ProductSmallCardsState();
}

class _ProductSmallCardsState extends State<ProductSmallCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(1, 1),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        width: 200,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  widget.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.price,
                    textScaleFactor: textScale(context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
