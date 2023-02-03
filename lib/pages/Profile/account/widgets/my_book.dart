import 'package:barber/api/bookApi/bookApi.dart';
import 'package:barber/pages/book/book_cards.dart';
import 'package:barber/pages/book/book_page.dart';
import 'package:barber/provider/globalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:barber/res/style/my_theme.dart';
class MyBook extends StatefulWidget {
  MyBook({Key? key}) : super(key: key);

  @override
  State<MyBook> createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
  List<IBook> booker = [];

  myBooks() async {
    List<IBook> data =
        await myBook(authToken: context.read<GlobalData>().loginToken!);
    booker = data;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    myBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/img/arrowBack.svg')),
          ],
        ),
        title: Text(
          'Мои книги',
          textScaleFactor: textScale(context),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
       
     
      body: booker == null
          ? SizedBox()
          : Column(
              children: [
                ...booker.map((e) => GestureDetector(
                      child: BookCard(
                          bookName: e.title,
                          img: e.img,
                          mentor: e.name,
                          price: e.price),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookInside(
                                      img: e.img!,
                                      nameBook: e.title!,
                                      nameMentor: e.name!,
                                      nameCat: e.catName!,
                                      idBook: e.id!,
                                      price: e.price!,
                                      pdf: e.file!,
                                      language: e.language!,
                                      age: e.age!,
                                      author: e.author!,
                                      bookPage: e.bookPage!,
                                      year: e.year!,
                                      genre: e.genre!,
                                      publish: e.publish!,
                                      info: e.info!,
                                    )));
                      },
                    ))
              ],
            ),
    );
  }
}
