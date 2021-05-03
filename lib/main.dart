import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wefinex/ui/home_screen.dart';
import 'package:wefinex/ui/not_found_page.dart';
import 'package:wefinex/utils/route_generator.dart';
import 'package:wefinex/utils/uidata.dart';

import 'utils/uidata.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            platform: TargetPlatform.iOS,
            scaffoldBackgroundColor: Colors.white,
            // primaryColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: MyColors.redMedium,
              iconTheme: new IconThemeData(color: Colors.white),
            ),
            // primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white, size: 28),
            // backgroundColor: Colors.white,
            fontFamily: Config.defaultFont),
        home: Home(),
        onGenerateRoute: RouteGenerator.authorizedRoute,
        onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
            fullscreenDialog: false, builder: (context) => new NotFoundPage()));
  }
}
