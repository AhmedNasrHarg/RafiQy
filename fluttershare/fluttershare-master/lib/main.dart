import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttershare/localization/demo_localiztion.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/routes/custom_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale (BuildContext context,Locale locale)
  {
    _MyAppState state =context.findAncestorStateOfType<_MyAppState>();
    state.setLocal(locale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Locale _locale;

  void setLocal(Locale locale)
  {
    setState(() {
      _locale=locale;
    });
  }

  @override
  void didChangeDependencies() {
getLocale().then((locale){
  setState(() {
    this._locale=locale;
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
    }
    else{
    return MaterialApp(
      title: 'FlutterShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal // secondryColor
      ),
      home: Home(),
       locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'SA')
        ],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportLocales) {
          for (var locale in supportLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode
            ) {
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