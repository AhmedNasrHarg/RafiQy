import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttershare/classes/learn_hive.dart';
import 'package:fluttershare/localization/demo_localiztion.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/root_page.dart';


import 'package:fluttershare/pages/situation-grid.dart';

import 'package:fluttershare/routes/custom_router.dart';
import 'package:fluttershare/services/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
  //   print("Timestamps enabled in snapshots\n");
  // }, onError: (_) {
  //   print("Error enabling timestamps in snapshots\n");
  // });
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
//      MaterialApp(
//    title: 'Navigation Basics',
//    debugShowCheckedModeBanner: false,
//    home:
      MyApp()
//  )
      );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocal(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  void initState() {
    super.initState();
    LearnHive();

//    Firestore.instance.settings(persistenceEnabled: true);
  }

  @override
  void dispose() {
//    didReceiveLocalNotificationSubject.close();
//    selectNotificationSubject.close();
    super.dispose();
  }

  void setLocal(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: 'FlutterShare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.teal // secondryColor
            ),

        home: RootPage(auth: new Auth()),
        locale: _locale,
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportLocales) {
          for (var locale in supportLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportLocales.first;
        },
        onGenerateRoute: CustomRouter.allRoutes,
        // initialRoute: homeRoute,
      );
    }
  }
}
