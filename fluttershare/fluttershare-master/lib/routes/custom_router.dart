
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/album_page.dart';
import 'package:fluttershare/pages/learn_details_page.dart';
import 'package:fluttershare/pages/learn_page.dart';
import 'package:fluttershare/routes/route_names.dart';
class  CustomRouter {
  static Route<dynamic>allRoutes(RouteSettings settings)
  {
    switch(settings.name)
    {
      case learnRoute:
        return MaterialPageRoute(builder: (_)=>LearnPage());
      case learnDetailsRoute:
        return MaterialPageRoute(builder: (_)=>LearnDetailsPage());
      case albumRoute:
        return MaterialPageRoute(builder: (_)=>AlbumPage());
    }
  }
}