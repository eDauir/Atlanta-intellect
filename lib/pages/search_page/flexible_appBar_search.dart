import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';

class FlexSearch extends StatefulWidget {
  FlexSearch({Key? key}) : super(key: key);

  @override
  State<FlexSearch> createState() => _FlexSearchState();
}

class _FlexSearchState extends State<FlexSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                  constraints: BoxConstraints(maxWidth: 800, maxHeight: 35),
                  fillColor: greys,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: () {}, child: Text('Courses')),
                  OutlinedButton(onPressed: () {}, child: Text('Mentors'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
