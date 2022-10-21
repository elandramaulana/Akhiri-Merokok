import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/providers/my_shared_pref.dart';
import 'core/theme/my_theme.dart';
import 'core/utils/fcm_helper.dart';
import 'core/values/languages/localization_service.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preference = await SharedPreferences.getInstance();
  initScreen = preference.getInt('initScreen');
  await preference.setInt('initScreen', 1);

  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.red,
        locked: true,
        importance: NotificationImportance.High,
        // soundSource: 'resource://raw/res_custom_notification',
        channelDescription: 'Masukkan jumlah konsumsi rokokmu hari ini',
      ),
    ],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FcmHelper.initFcm();

  await MySharedPref.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(
      // xd art board size
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: "Akhiri Merokok",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                // prevent font from scalling (some people use big/small device fonts)
                // but we want our app font to still the same and dont get affected
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialRoute:
              AppPages.INITIAL, // first screen to show when app is running

          getPages: AppPages.routes, // app screens
          locale: MySharedPref.getCurrentLocal(), // app language
          translations:
              LocalizationService(), // localization services in app (controller app language)
        );
      },
    );
  }
}
