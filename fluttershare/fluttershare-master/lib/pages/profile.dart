
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/language.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  Profile({Key key}):super(key:key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _changeLanguage(Language language) async
  {
  Locale _temp=await setLocale(language.languageCode);

  MyApp.setLocale(context,_temp);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold
      (
      appBar: AppBar(
        title: Text(getTranslated(context, "project_name")??"CBTTeam" ,
        style: TextStyle(
           color: Colors.white,
        fontFamily: "Signatra",
        fontSize:50.0,
         
        ),
        
        ),  
//          (DemoLocalization.of(context).getTranslatedValues('home_page')),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButton(
              onChanged: (Language language){
                _changeLanguage(language);
              },
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              items: Language.languageList().map((lang)=>DropdownMenuItem(value: lang,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[Text(lang.flag),Text(lang.name,style: TextStyle(fontSize: 30),)],
              ),
              ))
                  .toList(),


            ),

            )
    ],
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
          )
,body: linearProgress()

      );

  }
}



