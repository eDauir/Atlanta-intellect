import 'package:barber/provider/globalData.dart';
import 'package:barber/res/anyFunction.dart';
import 'package:barber/res/style/my_theme.dart';
import 'package:barber/routing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: must_be_immutable

ThemeProvider _themeManager = ThemeProvider();

class App extends StatefulWidget {
  String url;
  App({Key? key, required this.url}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  void dispose() {
    _themeManager.removeListener(() {
      themeListener();
    });
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(() {
      themeListener();
    });
    // TODO: implement initState
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = goRouterShow(url: widget.url, theme: _themeManager);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        // localizationsDelegates: [
        //       GlobalMaterialLocalizations.delegate,
        //       GlobalWidgetsLocalizations.delegate,
        //       GlobalCupertinoLocalizations.delegate,
        //     ],
        //     supportedLocales: [
        //       const Locale('kz'),
        //     ],
        theme: light,
        darkTheme: dark,
        themeMode: context.watch<GlobalData>().darkMode == true
            ? ThemeMode.dark
            : ThemeMode.light,
        // localizationsDelegates: [GlobalMaterialLocalizations.delegate],

        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        debugShowCheckedModeBanner: false,
        routeInformationProvider: goRouter.routeInformationProvider,
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Atlanta',
      ),
    );
  }
}
