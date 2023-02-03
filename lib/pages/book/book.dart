import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/Category/categoryApi.dart';
import 'package:barber/api/bookApi/bookApi.dart';
import 'package:barber/pages/Home/components/sliderBanner.dart';
import 'package:barber/pages/book/book_cards.dart';
import 'package:barber/pages/book/book_page.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<IBook> booker = [];
  List<ICategory> categ = [];
  bool loaded = false;
  String searcKey = '';
  String catName = '';
  int currentPage = 1;
  int allPage = 1;
  int currentCategoryId = 0;

  loadBook({String page = '1', bool update = true}) async {
    List<Books> data =
        await getBook(page: page, searchKey: searcKey, catName: catName);
    allPage = data[0].count!;
    categ = await getCategory();
    if (update) booker.clear();
    if (update) currentPage = 1;
    if (data.isNotEmpty) {
      data[0].books?.forEach(
        (element) {
          booker.add(element);
        },
      );
    }
    loaded = true;
    setState(() {});
  }

  String searchKeyInput = '';
  bool isLoadPress = false;
  late FocusNode focusNode;
  final myController = TextEditingController();

  onSubmit(String value) async {
    searchKeyInput = myController.text;
    setState(() {
      searcKey = searchKeyInput;
    });
    loadBook(page: '1');
  }

  // initState
  @override
  void initState() {
    super.initState();
    loadBook();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Column(
            children: [
              Container(
                constraints:
                    BoxConstraints(maxHeight: marginScale(context, 40)),
                margin: EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: myController,
                  decoration: InputDecoration(
                      hintText: 'Что ищете?',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(
                              fontWeight: FontWeight.w300, color: Colors.grey),
                      // label: Text(
                      //   'Что ищете?',
                      //   style: Theme.of(context).textTheme.headline5!.copyWith(
                      //       fontWeight: FontWeight.w300, color: Colors.grey),
                      // ),
                      fillColor: focusNode.hasFocus
                          ? inputBg.withOpacity(0.1)
                          : Colors.grey[200],
                      filled: true,
                      isDense: true,
                      // fillColor: inputBg,
                      // filled: true,
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primary_color, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      prefixIcon: Container(
                          width: marginScale(context, 11.67),
                          height: marginScale(context, 11.67),
                          margin: EdgeInsets.only(
                              right: marginScale(context, 10),
                              left: marginScale(context, 15)),
                          child: SvgPicture.asset(
                            'assets/img/searchForSearchPage.svg',
                            width: marginScale(context, 11.67),
                            height: marginScale(context, 11.67),
                            color: focusNode.hasFocus
                                ? primary_color
                                : Colors.grey[400],
                          )),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#F8F8F8'), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelStyle: TextStyle(color: primary_color)),
                  onFieldSubmitted: (value) {
                    onSubmit(value);
                    isLoadPress = true;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SliderBanner(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: marginScale(context, 5)),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: currentCategoryId == 0
                                      ? primary_color
                                      : colorWhite),
                              onPressed: () async {
                                setState(() {
                                  catName = '';
                                  currentCategoryId = 0;
                                });
                                loadBook(page: '1');
                              },
                              child: Text(
                                '🔥 Все',
                                style: TextStyle(
                                    color: currentCategoryId == 0
                                        ? colorWhite
                                        : primary_color),
                              ))),
                      ...categ.map(
                        (e) => category(context, e.name!, e.id),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
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
              ),
              if (allPage > currentPage)
                Padding(
                    padding: EdgeInsets.all(50),
                    child: ElevatedButton(
                      onPressed: () {
                        if (allPage == currentPage) return;
                        setState(() {
                          currentPage++;
                        });
                        loadBook(page: currentPage.toString(), update: false);
                      },
                      child: Text('Показать еще'),
                    )),
            ],
          )
        : CircularProgressIndicator();
  }

  Container category(BuildContext context, String text, id) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: marginScale(context, 5)),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: currentCategoryId == int.parse(id)
                    ? primary_color
                    : colorWhite),
            onPressed: () async {
              setState(() {
                catName = id;
                currentCategoryId = int.parse(id);
              });
              loadBook(page: '1');
            },
            child: Text(text,
                textScaleFactor: textScale(context),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: currentCategoryId == int.parse(id)
                        ? colorWhite
                        : primary_color))));
  }
}
