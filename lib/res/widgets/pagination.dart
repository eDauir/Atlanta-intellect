import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  num AllEndPage;
  num currentPage;
  Function changePage;

  Pagination(
      {Key? key,
      required this.AllEndPage,
      required this.currentPage,
      required this.changePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num startPage = currentPage;
    late num endPage;

    List pagination = [];

    if (currentPage != 1) {
      pagination.add(1);
    }

    if (startPage + 5 == AllEndPage) {
      endPage = AllEndPage;
    }

    if (startPage + 5 < AllEndPage) {
      endPage = startPage + 5;
    } else {
      endPage = startPage + (AllEndPage - startPage);
    }

    for (var i = startPage; i <= endPage; i++) {
      pagination.add(i);
    }

    return Wrap(
      children: [
        if (AllEndPage == 1) pointer('1', true),
        if (AllEndPage > 1)
          TextButton(
              onPressed: () async {
                if (currentPage > 1) {
                  await changePage(page: (currentPage - 1).toString());
                }
              },
              child: Icon(Icons.arrow_back_ios_new)),
        if (AllEndPage > 1)
          ...pagination.map((e) {
            var s = pointer(e.toString(), e == currentPage ? true : false);
            return s;
          }),
        if (AllEndPage > 1)
          TextButton(
              onPressed: () async {
                if (currentPage < AllEndPage) {
                  await changePage(page: (currentPage + 1).toString());
                }
              },
              child: Icon(Icons.arrow_forward_ios_rounded)),
      ],
    );
  }

  Widget pointer(String num, [bool isCurrent = false]) {
    return TextButton(
        onPressed: () async {
          await changePage(page: num);
        },
        child: Text(
          num,
          style: TextStyle(color: isCurrent ? primary_color : greys.withOpacity(1)),
        ));
  }
}
