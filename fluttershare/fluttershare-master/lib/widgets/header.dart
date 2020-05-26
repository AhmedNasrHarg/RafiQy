import 'package:flutter/material.dart';

header(context,{bool isAppTitle = false, String titleText, removeBackButton = false, bool hasAction = false,bool isIcon = false, String actionName, IconData actionIcon, Function actionFunction}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "RafiQ" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily:isAppTitle ?  "Signatra" : "",
        fontSize:isAppTitle ? 50.0 : 22.0,
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

