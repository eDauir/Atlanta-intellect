import 'dart:ui';

import 'package:barber/res/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextTheme light_text = TextTheme(
  headline1:
      TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: darkColor),
  headline2:
      TextStyle(color: darkColor, fontWeight: FontWeight.w700, fontSize: 20),
  headline3:
      TextStyle(color: darkColor, fontWeight: FontWeight.w700, fontSize: 18),
  headline4:
      TextStyle(color: darkColor, fontWeight: FontWeight.w600, fontSize: 14),
  headline5:
      TextStyle(color: darkColor, fontWeight: FontWeight.w600, fontSize: 12),
  headline6:
      TextStyle(color: darkColor, fontSize: 8, fontWeight: FontWeight.w500),
  bodyText1: TextStyle(color: darkColor),
  bodyText2: TextStyle(color: darkColor, fontSize: 20),
  subtitle1: TextStyle(
      color: darkColor, fontSize: 15, fontWeight: FontWeight.w600), //h5 2
  subtitle2:
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
);

TextStyle headLine7 = TextStyle(fontSize: 8, fontWeight: FontWeight.w500);
TextStyle headLine5Med = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  fontFamily: 'MontserratAlternates',
);
TextStyle headLine5Reg = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: darkColor,
  fontFamily: 'MontserratAlternates',
);
TextStyle headLine4Med = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 14,
  color: darkColor,
  fontFamily: 'MontserratAlternates',
);
TextStyle headLine4Reg = TextStyle(
  color: darkColor,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  fontFamily: 'MontserratAlternates',
);

// Responsive
const mockupHeight = 568;
const mockupWidth = 320;

double scale(context) {
  final width = MediaQuery.of(context).size.width;
  return mockupWidth / width;
}

double textScale(context) {
  final width = MediaQuery.of(context).size.width;
  return width / mockupWidth;
}

double marginScale(context, size) {
  final width = MediaQuery.of(context).size.width;
  return size / mockupWidth * width;
}

//! Responsive

// const mockupHeight = 812;
const mockupWidthXL = 375;

getWidthScreen() {
  var pixelRatio = window.devicePixelRatio;
  var logicalScreenSize = window.physicalSize / pixelRatio;
  var logicalWidth = logicalScreenSize.width;
  var logicalHeight = logicalScreenSize.height;
  return logicalWidth;
}

double scaleWC() {
  return mockupWidthXL / getWidthScreen();
}

double textScaleWC() {
  return getWidthScreen() / mockupWidthXL;
}

double marginScaleWC(size) {
  return size / mockupWidthXL * getWidthScreen();
}
//! Responsive END

// ! margin

sizeWidth(double width) => SizedBox(
      width: marginScaleWC(width),
    );
sizeHeight(double height) => SizedBox(
      height: marginScaleWC(height),
    );

// ! margin end

//

TextStyle headline5Semi =
    TextStyle(color: darkColor, fontWeight: FontWeight.w500, fontSize: 16);

BoxShadow shadow = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  spreadRadius: 2,
  blurRadius: 5,
  offset: Offset(3, 3),
);

BorderRadiusGeometry borderRadius = BorderRadius.circular(10);
Color colorWhite = Colors.white;

TextTheme dark_text = TextTheme(
  headline6: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
);
Color greys = Colors.grey.withOpacity(0.1);

Color greysForText = HexColor('#808080');

//!! Color primary_color = HexColor('#335EF7');
Color primary_color = HexColor('#00677D');

// bg opacity
Color bgPrimaryColor = primary_color.withOpacity(0.1);

// Color primary_dark = HexColor('#335EF7');
Color primary_dark = primary_color;
const Color primary_light = Colors.blue;

Color black = HexColor('#202021');

// TEXTFORMBG
Color inputBg = HexColor('#6F3DFF');

// SCAFOLDBG
Color scafoldBg = HexColor('#FDFDFD');

// BottomBar
Color bottomBarColor = HexColor('#FAFAFA');

// bg
Color homeBg = HexColor('#FDFDFD');

// color Start
// colorStar
Color colorStar = HexColor('#FA9F18');

HexColor clrDark = HexColor('#1F222A');
HexColor canvas = HexColor('#181A20');
Color fColorDark = Colors.black;

// orange
Color orange = HexColor('#FA9F18');
Color colorsRed = HexColor('#E74C3C');
Color colorsGreen = HexColor('#2ECC71');

//
// COLORS ORANGE
Color colorsOrange = HexColor('#FF9800');

Color color4 = HexColor('#EFF3FF');

// NEW COLOR
Color greyColor = HexColor('#9E9E9E');
Color lightGrey = HexColor('#DADADA');
Color bgColor = HexColor('#FDFDFD');
Color darkColor = HexColor('#2F2F2F');
Color redColor = HexColor('#E74C3C');
Color primary_opac = primary_color.withOpacity(0.1);

// ! LIGHT
ThemeData light = ThemeData(
        scaffoldBackgroundColor: bgColor,
        fontFamily: 'MontserratAlternates',
        focusColor: darkColor,
        shadowColor: Colors.grey.withOpacity(0.1),
        cardColor: Colors.white,
        brightness: Brightness.light,
        textTheme: light_text,
        primaryColor: primary_light,
        iconTheme: IconThemeData(color: primary_color),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            // foregroundColor: darkColor,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 23,
            )),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 26,
          ),
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: primary_dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                // elevation: 15,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                textStyle: TextStyle(
                    fontFamily: 'MontserratAlternates',
                    color: darkColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                minimumSize: Size.fromHeight(50),
                shadowColor: primary_dark)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.red;
            }
            if (states.contains(MaterialState.selected)) {
              return primary_color;
            }
            return primary_color;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.amber;
            }
            if (states.contains(MaterialState.selected)) {
              return primary_color;
            }
            return greyColor;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(primary_color)))
    .copyWith(
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    side: BorderSide(
      color: primary_dark,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    foregroundColor: primary_dark,
  )),
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: primary_color,
      ),
);

//! DARK
ThemeData dark = light.copyWith(
    shadowColor: darkColor.withOpacity(0.1),
    cardColor: clrDark,
    brightness: Brightness.dark,
    primaryColor: clrDark,
    textTheme: light_text,
    canvasColor: Colors.grey,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: AppBarTheme(color: clrDark));

InputDecoration customDec(
        {String? hintext,
        String? lab,
        Icon? icon,
        Widget? sufIcon,
        IconData? icons,
        double? radius,
        bool isActive = false,
        BuildContext? context,
        bool notPrefix = false}) =>
    InputDecoration(
      focusColor: primary_color,
      hintText: isActive ? hintext ?? 'Введите адрес эл. почты' : null,
      label: isActive ? null : Text(hintext ?? 'Введите адрес эл. почты'),
      fillColor: HexColor('#F8F8F8'),
      filled: true,
      isDense: true,
      contentPadding: isActive
          ? EdgeInsets.fromLTRB(
              25, marginScale(context, 28), marginScale(context, 28), 0)
          : null,
      floatingLabelStyle: TextStyle(color: primary_color),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? 20),
        borderSide: BorderSide(
          width: 2,
          color: primary_color,
        ),
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(radius ?? 20)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.circular(radius ?? 20)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: primary_color),
          borderRadius: BorderRadius.circular(radius ?? 20)),
      prefixIcon: notPrefix == true
          ? null
          : Padding(
              padding: EdgeInsets.only(left: 10, right: 5, bottom: 2),
              child: icon == null
                  ? icons != null
                      ? Icon(
                          icons,
                        )
                      : Icon(
                          Icons.mail,
                        )
                  : icon),
      suffixIcon: sufIcon,
      labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: HexColor('#808080')),
    );

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  get themeMode => _themeMode;
  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// FONTS

InputDecoration searchInput(
        {required BuildContext context,
        required FocusNode focusNode,
        bool isShowPrefix = true,
        String? text}) =>
    InputDecoration(
        hintText: text ?? '',
        hintStyle: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontWeight: FontWeight.w300, color: Colors.grey),
        // label: Text(
        //   'Что ищете?',
        //   style: Theme.of(context).textTheme.headline5!.copyWith(
        //       fontWeight: FontWeight.w300, color: Colors.grey),
        // ),
        fillColor:
            focusNode.hasFocus ? inputBg.withOpacity(0.1) : Colors.grey[200],
        filled: true,
        isDense: true,
        // fillColor: inputBg,
        // filled: true,
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary_color, width: 1.0),
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
              color: focusNode.hasFocus ? primary_color : Colors.grey[400],
            )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#F8F8F8'), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelStyle: TextStyle(color: primary_color));
