import 'dart:async';
import 'dart:io';

import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/payboxApi.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/book/book_reader.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import '../../api/bookApi/bookApi.dart';

class BookInside extends StatefulWidget {
  String img;
  String nameBook;
  String nameMentor;
  String nameCat;
  String idBook;
  String price;
  String pdf;
  String author;
  String year;
  String publish;
  String genre;
  String age;
  String bookPage;
  String language;
  String info;

  BookInside({
    Key? key,
    required this.img,
    required this.nameBook,
    required this.nameCat,
    required this.idBook,
    required this.price,
    required this.pdf,
    required this.nameMentor,
    required this.author,
    required this.year,
    required this.publish,
    required this.genre,
    required this.age,
    required this.bookPage,
    required this.language,
    required this.info,
  }) : super(key: key);

  @override
  State<BookInside> createState() => _BookInsideState();
}

class _BookInsideState extends State<BookInside> {
  //PDF
  bool isDownload = false;
  String remotePDFpath = "";
  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = widget.pdf;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      isDownload = true;
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

//Buy
  List<IBook> booker = [];
  String payboxLink = '';
  bool getLog = false;
  var login;
  bool isBuy = false;
  myBooks(token) async {
    List<IBook> data = await myBook(authToken: token);
    booker = data;
    booker.forEach((element) {
      if (element.id == widget.idBook) {
        isBuy = true;
      }
    });
    setState(() {});
  }

  checkAuth() async {
    login = await getCheckedLogin();
    if (login.isNotEmpty) {
      getLog = true;
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
    myBook(authToken: authToken);
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.35,
              flexibleSpace: Image.network(
                widget.img,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.nameBook,
                style: Theme.of(context).textTheme.headline2,
                //textScaleFactor: textScale(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  widget.nameMentor,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w400),
                  //textScaleFactor: textScale(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  catName(
                      context, widget.nameCat, bgPrimaryColor, primary_color),
                  catName(context, 'PDF', Colors.green.withOpacity(0.1),
                      Colors.green),
                ],
              ),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  'О чем это книга?',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                  //textScaleFactor: textScale(context),
                ),
              ),
              Text(
                widget.info,
                style: Theme.of(context).textTheme.headline5,
                //textScaleFactor: textScale(context),
              ),
              Divider(
                height: 30,
                color: Colors.grey.withOpacity(0.5),
              ),
              infoMore(context, 'Автор', widget.author),
              infoMore(context, 'Издательство', widget.publish),
              infoMore(context, 'Год выпуска', widget.year),
              infoMore(context, 'Жанр', widget.genre),
              infoMore(context, 'Возраст', widget.age),
              infoMore(context, 'Страниц', widget.bookPage),
              infoMore(context, 'Язык', widget.language),
            ]),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          child: Text((context.read<GlobalData>().isCurator || isBuy)
              ? 'Читать'
              : 'Купить'),
          onPressed: () async {
            //NoAuth
            if (getLog == false) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(marginScale(context, 20)))),
                      contentPadding: EdgeInsets.zero,
                      actionsPadding: EdgeInsets.symmetric(
                          horizontal: marginScale(context, 20),
                          vertical: marginScale(context, 20)),
                      actionsAlignment: MainAxisAlignment.center,
                      alignment: Alignment.center,
                      actions: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/img/account.svg'),
                            SizedBox(
                              height: marginScale(context, 15),
                            ),
                            Text(
                              'Аккаунт',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: primary_color),
                            ),
                            SizedBox(
                              height: marginScale(context, 15),
                            ),
                            Text(
                              'Для покупки требуется авторизация',
                              style: headLine5Med,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: marginScale(context, 20),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                context.go('/profile');
                              },
                              child: Text('Перейти'),
                            )
                          ],
                        )
                      ],
                    );
                  });
            }
            //Don't Check
            if (mailStatus == false) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(marginScale(context, 20)))),
                      contentPadding: EdgeInsets.zero,
                      actionsPadding: EdgeInsets.symmetric(
                          horizontal: marginScale(context, 20),
                          vertical: marginScale(context, 20)),
                      actionsAlignment: MainAxisAlignment.center,
                      alignment: Alignment.center,
                      actions: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/img/confirm.svg'),
                            SizedBox(
                              height: marginScale(context, 15),
                            ),
                            Text(
                              'Подтвердите Email ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: primary_color),
                            ),
                            SizedBox(
                              height: marginScale(context, 15),
                            ),
                            Text(
                              'Для покупки требуется подтверждение аккаунта',
                              style: headLine5Med,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: marginScale(context, 20),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                context.go('/profile');
                              },
                              child: Text('Перейти'),
                            )
                          ],
                        )
                      ],
                    );
                  });
            }
            //Curator
            if (context.read<GlobalData>().isCurator || isBuy) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookReader(
                            pdf: remotePDFpath,
                            isLoad: isDownload,
                          )));
            }

            //PayBox
            if (context.read<GlobalData>().isCurator == false) {
              String login = context.read<GlobalData>().loginToken ?? '';
              if (login.isEmpty) return;
              Map paramsToQuery = {'authToken': login, 'bookId': widget.idBook};

              var res = await buyFromPaybox(
                  widget.price, widget.nameBook, 'buyBook', paramsToQuery);
              if (res != false) if (await canLaunchUrl(Uri.parse(res))) {
                await launchUrl(Uri.parse(res));
                setState(() {
                  payboxLink = res;
                });
              } else
                print('DONT OPEN');
              else
                print('ERROR');
              await Future.delayed(Duration(milliseconds: 900));
              while (WidgetsBinding.instance?.lifecycleState !=
                  AppLifecycleState.resumed) {
                await Future.delayed(Duration(milliseconds: 100));
              }
            }
          },
        ),
      ),
    );
  }

  Padding infoMore(BuildContext context, String constanta, String mani) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            constanta,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w600),
            //textScaleFactor: textScale(context),
          ),
          Text(
            mani,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w500),
            //textScaleFactor: textScale(context),
          )
        ],
      ),
    );
  }

  Container catName(
      BuildContext context, String catName, Color color, Color textColor) {
    return Container(
        margin: EdgeInsets.only(
            top: marginScale(context, 10), bottom: marginScale(context, 10)),
        padding: EdgeInsets.symmetric(
            horizontal: marginScale(context, 8),
            vertical: marginScale(context, 5)),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(
          catName ?? '',
          textScaleFactor: textScale(context),
          style: headLine7.copyWith(color: textColor, fontSize: 10),
        ));
  }
}
