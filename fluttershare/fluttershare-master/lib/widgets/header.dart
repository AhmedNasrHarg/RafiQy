import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';


header(context,{bool isAppTitle = false, String titleText, removeBackButton = false, bool hasAction = false,bool isIcon = false, String actionName, IconData actionIcon, Function actionFunction}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: SizedBox(
                width: 250.0,
                height: 40.0,
                child: AutoSizeText(
                  isAppTitle ? "RafiQ" : titleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily:isAppTitle ?  "Signatra" : "",
                    fontSize:isAppTitle ? 50.0 : 25.0,
                  ),
                  maxLines: 2,
                ),
              ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
    actions: hasAction ? [FlatButton(
      child: isIcon ? IconButton(
        onPressed: actionFunction,
        icon: Icon(
          actionIcon,
          size: 30.0,
          color: Colors.white,
          ),
      ) 
      : Text(
        actionName,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        ),
      onPressed: actionFunction,
    )] : null, 
  );
}

