import 'dart:async';
import 'dart:io';

import 'dart:ui';

import 'package:barber/api/Notification/INotification.dart';
import 'package:barber/api/Notification/notificationApi.dart';
import 'package:barber/generated/codegen_loader.g.dart';
import 'package:barber/pages/Profile/account/vars.dart';
import 'package:barber/pages/product_page/components/class_test.dart';
import 'package:barber/provider/favoriteData.dart';
import 'package:barber/provider/globalData.dart';
import 'package:barber/provider/homeData.dart';
import 'package:barber/provider/productData.dart';
import 'package:barber/provider/profileData.dart';
import 'package:barber/reload.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  const simplePeriodicTask = "simplePeriodicTask";

  void showNotification(t, v, flp) async {
    var android = AndroidNotificationDetails(
      'channel id',
      'channel NAME',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
    );
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flp.show(
      1,
      t,
      '$v',
      platform,
      payload: 'VIS \n $v',
    );
  }

  var android = AndroidInitializationSettings('@mipmap/launcher_icon');
  var iOS = IOSInitializationSettings();
  var initSetttings = InitializationSettings(android: android, iOS: iOS);
  flp.initialize(initSetttings);

  FlutterBackgroundService().invoke("setAsForeground");

  Timer.periodic(const Duration(days: 1), (timer) async {
    List<INotification> notis = await getNotification(authToken);

    var dataData =
        DateTime.parse(notis[0].notify!.entries.first.value[0]['date']).day;
    if (dataData == DateTime.now().day) {
      showNotification(notis[0].notify!.entries.first.value[0]['text'],
          notis[0].notify!.entries.first.value[0]['title'], flp);

      EncryptedSharedPreferences encryptedSharedPreferences =
          EncryptedSharedPreferences();
      encryptedSharedPreferences.getString('noty').then((value) {
        encryptedSharedPreferences.setString('noty', 'true');
      }).catchError((onError) {
        encryptedSharedPreferences.setString('noty', 'true');
      });
    }
  });
}

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // Wakelock.toggle(enable: true);
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

 await initializeService();

  runApp(EasyLocalization(
    supportedLocales: [Locale('ru'), Locale('kk')],
    path: 'assets/i18n',
    fallbackLocale: Locale('ru'),
    assetLoader: CodegenLoader(),
    child: MultiProvider(providers: [
      ChangeNotifierProvider<GlobalData>(create: (context) => GlobalData()),
      ChangeNotifierProvider<Counter>(create: (context) => Counter()),
      ChangeNotifierProvider<ProfileData>(create: (context) => ProfileData()),
      ChangeNotifierProvider<HomeData>(create: (context) => HomeData()),
      ChangeNotifierProvider<FavoriteData>(create: (context) => FavoriteData()),
      ChangeNotifierProvider<ProductData>(create: (context) => ProductData()),
    ], child: Reload()),
  ));

  HttpOverrides.global = PostHttpOverrides();
}
