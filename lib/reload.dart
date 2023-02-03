import 'package:barber/api/Banner/IBanner.dart';
import 'package:barber/api/Banner/bannerApi.dart';
import 'package:barber/api/Category/ICategory.dart';
import 'package:barber/api/Category/categoryApi.dart';
import 'package:barber/api/FAQ/IFaq.dart';
import 'package:barber/api/FAQ/faqApi.dart';
import 'package:barber/api/Favorite/favoriteApi.dart';
import 'package:barber/api/Mentors/IMentor.dart';
import 'package:barber/api/Mentors/mentorsApi.dart';
import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/api/Notification/notificationApi.dart';
import 'package:barber/api/Tarif/ITarif.dart';
import 'package:barber/api/Tarif/tarifApi.dart';
import 'package:barber/api/checkAuth.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/home/homeApi.dart';
import 'package:barber/api/profileApi.dart';
import 'package:barber/app.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/product_page/components/test.dart';
import 'package:barber/provider/favoriteData.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/provider/profileData.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Reload extends StatefulWidget {
  const Reload({
    Key? key,
  }) : super(key: key);

  @override
  State<Reload> createState() => _Reload();
}

class _Reload extends State<Reload> with TickerProviderStateMixin {
  // late var login;
  bool loadEnd = false;

  String url = '/';

  String tokenLogin = '';

  ifShowWelcome() async {
    EncryptedSharedPreferences encryptedSharedPreferences =
        EncryptedSharedPreferences();

    encryptedSharedPreferences.getString('welcome').then((value) {
      if (value == '') {
        encryptedSharedPreferences.setString('welcome', 'true');
        url = '/welcome';
      } else {
        if (tokenLogin.isEmpty || tokenLogin == '') {
          url = '/auth';
        } else {
          url = '/';
        }
      }
    }).catchError((onError) {
      encryptedSharedPreferences.setString('welcome', 'true');
      url = '/welcome';
    });
    setState(() {});
  }

  checkAuth() async {
    var login = await getCheckedLogin();
    if (login.isNotEmpty) {
      tokenLogin = login;
      context.read<GlobalData>().setLoginToken(login);
      var arr = await getFavoriteCardId(login);
      if (arr != null) {
        context.read<FavoriteData>().setFavoriteCardsId(arr);
      }
    } else {
      tokenLogin = '';
      context.read<GlobalData>().setLoginToken('');
    }
  }

  getData() async {
    await getImages();
    await getMentorsData();
    await getCategoryData();
    await getCards();
    await getFaqData();

    await Future.delayed(Duration(seconds: 2), () {});

    await getInitDataWithToken(context: context, tokenLogin: tokenLogin);
    rotateController!.forward();
    myAnimationController!.forward();
    // setState(() {});
    Future.delayed(Duration(milliseconds: 800), () {
      myAnimationController!.stop();
      rotateController!.stop();
      pulsController!.stop();
      setState(() {
        loadEnd = true;
      });
    });
  }

  // SLIDER BANNER
  getImages() async {
    List<IBanner>? imgList = await getBanner();
    if (imgList != null) {
      context.read<GlobalData>().setBannerList = imgList;
    }
  }

  // get Mentors
  getMentorsData() async {
    List<IMentor>? data = await getMentors();
    if (data != null) {
      context
          .read<GlobalData>()
          .setMentors(data[0].workers!, data[0].count!, data[0].total ?? '1');
    }
  }

  // get Category
  getCategoryData() async {
    List<ICategory>? categories = await getCategory();
    if (categories != null) {
      context.read<GlobalData>().setCategory(categories);
    }
  }

  // get Cards
  getCards() async {
    List<IHome>? data = await getProduct();
    if (data != null) {
      context.read<HomeData>().setProducts(
          data[0].products!, data[0].count ?? 1, data[0].total, '🔥 Все');
    }
  }

  // get FAQ
  getFaqData() async {
    List<IFaq> data = await getFAQ();
    context.read<GlobalData>().setFaq(data);
  }

  AnimationController? myAnimationController;
  AnimationController? pulsController;
  AnimationController? rotateController;

  Animation<double>? animation;

  Animation<double>? scaleValue;
  var squareScaleB = 1.0;

  Animation<double>? rotateValue;

  @override
  void initState() {
    super.initState();

    myAnimationController = AnimationController(
      duration: Duration(milliseconds: 1350),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    scaleValue = new Tween(
      begin: 0.32,
      end: 15.0,
    ).animate(new CurvedAnimation(
        parent: myAnimationController!, curve: Curves.ease));

    rotateController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    rotateValue = new Tween(
      begin: 0.0,
      end: 1.5,
    ).animate(
        new CurvedAnimation(parent: rotateController!, curve: Curves.ease));

    pulsController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 1,
      upperBound: 1.1,
    )
      ..forward()
      ..addListener(() {
        if (pulsController!.isCompleted) {
          pulsController!.repeat();
        } else {
          setState(() {
            squareScaleB = pulsController!.value;
          });
        }
      });
    ;

    setState(() {});

    Future.delayed(Duration.zero, () async {
      await checkAuth();
      await ifShowWelcome();
      await getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    myAnimationController!.dispose();
    rotateController!.dispose();
    pulsController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadEnd) {
      return App(
        url: url,
      );
    }
    if (myAnimationController == null ||
        pulsController == null ||
        rotateController == null) SizedBox();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: primary_dark,
          body: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      // height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Column(
                            children: [
                              !myAnimationController!.isAnimating
                                  ? Transform.scale(
                                      scale: squareScaleB,
                                      child: SvgPicture.asset(
                                        'assets/img/reloadIcon.svg',
                                      ),
                                    )
                                  : ClipRRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: 1.0,
                                        child: Container(
                                          width: constraints.maxWidth,
                                          height: constraints.maxHeight,
                                          child: Transform.rotate(
                                            angle: rotateValue!.value,
                                            child: Transform.scale(
                                              scale: scaleValue!.value,
                                              child: SvgPicture.asset(
                                                'assets/img/reloadIcon.svg',
                                                // width: constraints.maxWidth,
                                                // height: constraints.maxHeight,
                                                // fit: BoxFit.contain,

                                                // w
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              // SizedBox(
                              //   height: 30,
                              // ),
                              // SvgPicture.asset('assets/img/reloadText.svg'),
                              // SizedBox(
                              //   height: 30,
                              // ),
                            ],
                          ),
                          SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 210,
                      ),
                      SvgPicture.asset('assets/img/reloadText.svg'),
                      SizedBox(
                        height: 30,
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(bottom: 50),
                      //     child: CircularProgressIndicator(
                      //       color: colorWhite,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getInitDataWithToken(
    {required BuildContext context, required String tokenLogin}) async {
  // get Profile Data
  getProfileData() async {
    if (tokenLogin.isNotEmpty) {
      var result = await profileQuery(tokenLogin, 'get');
      if (result == false) {
        await encryptedSharedPreferences.clear();
      } else {
        var statusUser = result['actS'][0]['editor'];
        context.read<GlobalData>().setIsCurator =
            statusUser == '5' ? true : false;
        context.read<GlobalData>().setIsCurator =
            statusUser == '3' ? true : false;
        context.read<GlobalData>().setIsMentor =
            statusUser == '1' ? true : false;
        mainMail = result['actS'][0]['mail'];
        if (result['actS'][0]['activeStatus'].toString() == '1') {
          mailStatus = true;
        }
        authToken = tokenLogin;
        nameController.text = result['main'][0]['name'];
        surnameController.text = result['main'][0]['surname'];
        loginController.text = result['actS'][0]['mail']; //mail ozgered
        constMail = result['actS'][0]['mail'];
        id = result['main'][0]['user_id'];
        aboutController.text = (result['main'][0]['about'] != null)
            ? result['main'][0]['about']
            : '';
        otchController.text = (result['main'][0]['otchestvo'] != null)
            ? result['main'][0]['otchestvo']
            : '';
        avatar = result['main'][0]['avatar'];

        selectedDate = (result['main'][0]['birthday'] != null)
            ? DateTime.parse(result['main'][0]['birthday'])
            : DateTime.parse('1931-01-01');

        pol = (result['main'][0]['pol'] != null)
            ? result['main'][0]['pol']
            : 'Пусто';
        if (pol == 'Мужской') {
          manChecked = true;
        }
        if (pol == 'Женский') {
          womanChecked = true;
        }

        teleController.text = (result['main'][0]['telephone'] != null)
            ? result['main'][0]['telephone']
            : 'Не введено';
        addressController.text =
            (result['main'][0]['geo'] != null) ? result['main'][0]['geo'] : '';
        aboutController.text = (result['main'][0]['about'] != null)
            ? result['main'][0]['about']
            : 'Не введено';

        context.read<ProfileData>().setInitValue(
            nameValue: nameController.text,
            surName: surnameController.text,
            addresValue: addressController.text,
            telVAlue: teleController.text,
            lastNameValue: otchController.text);

        profileDetected = true;
      }
    } else {
      profileDetected = false;
    }
  }

  getAllNotifications() async {
    List<INotification> noti = await getNotification(authToken);
    context.read<GlobalData>().setNoti = noti;
  }

  getTarifData() async {
    List<ITarif> data = await getTarif();
    context.read<GlobalData>().setTarif(data);

    if (data.isNotEmpty) {
      if (tokenLogin.isNotEmpty) {
        List<IBoughtTarif> mytarif = await getTarifBought(tokenLogin);

        context.read<GlobalData>().setMyTarif(mytarif);
      }
    }
  }

  await getProfileData();
  await getTarifData();
  await getAllNotifications();
}
