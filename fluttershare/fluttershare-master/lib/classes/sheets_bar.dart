import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';

class SheetsAppBar extends StatelessWidget{
  final double barHeight =66.0;
  const SheetsAppBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Center(child: Text(getTranslated(context, 'sheet_entery')),),
     
      
    );
  }

}