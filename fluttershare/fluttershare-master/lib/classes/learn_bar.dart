import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';

class LearAppBar extends StatelessWidget{
  final double barHeight =66.0;
  const LearAppBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Center(child: Text(getTranslated(context, 'learn_page')),),
     
      
    );
  }

}