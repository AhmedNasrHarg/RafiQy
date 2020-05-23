import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DemoLocalization
{
  final Locale locale;
  DemoLocalization(this.locale);
  
  static DemoLocalization of(BuildContext context)
  {
    return Localizations.of(context, DemoLocalization);
  }
  Map<String,String>_localizedValues;
  Future load() async{
    String jsonStringValues=
        await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
        Map<String,dynamic>mappedJson=json.decode(jsonStringValues);
        _localizedValues=mappedJson.map((key,value)=>MapEntry(key,value.toString()));
  }
  String getTranslatedValues(String key)
  {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<DemoLocalization>delegate=_DemoLocalzationDelegate();
}
class _DemoLocalzationDelegate extends LocalizationsDelegate<DemoLocalization>
{
  const _DemoLocalzationDelegate();
  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return ['en','ar'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    // TODO: implement load
    DemoLocalization localization =new DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_DemoLocalzationDelegate old)=>false;

}