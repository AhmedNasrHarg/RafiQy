import 'package:flutter/material.dart';


class Toggle extends StatefulWidget {
  final bool isText;
  final IconData tapOneIcon;
  final IconData tapTwoIcon;
  final String tapOneTitle;
  final String tapTwoTitle;
  final Function toggleFunction;
  Toggle(context,{this.isText = true, this.tapOneIcon,this.tapTwoIcon,this.tapOneTitle,this.tapTwoTitle,this.toggleFunction});


  @override
  _ToggleState createState() => _ToggleState(isText: this.isText);
}

class _ToggleState extends State<Toggle> {

  bool isText;
  bool isTapOne = true;


  _ToggleState({this.isText});
  @override
  Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))
    ),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: isText ? 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapOne = true;
                    });
                    widget.toggleFunction("tapOne");
                  },
                  child: Text(
                    widget.tapOneTitle,
                    style: TextStyle(
                      color:isTapOne ?  Colors.white : Colors.grey[600],
                      fontSize: isTapOne ? 20.0 : 16.0,
                      fontWeight: isTapOne ? FontWeight.bold : FontWeight.normal
                    ),
                    ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isTapOne = true;
                    });
                    widget.toggleFunction("tapOne");
                  },
                icon: Icon(widget.tapOneIcon),
                color: isTapOne ? Colors.white : Colors.grey[600]
              ),
          ), 
          Padding(
            padding: EdgeInsets.all(8.0),
                child: isText ?  
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapOne = false;
                    });
                    widget.toggleFunction("tapTwo");
                  },
                  child: Text(
                    widget.tapTwoTitle,
                    style: TextStyle(
                      color: isTapOne ? Colors.grey[600] : Colors.white,
                      fontSize: isTapOne ? 16.0 : 20.0,
                      fontWeight: isTapOne ? FontWeight.normal : FontWeight.bold
                    ),
                    ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isTapOne = false;
                    });
                    widget.toggleFunction("tapTwo");
                  },
                icon: Icon(widget.tapTwoIcon),
                color: isTapOne ? Colors.grey[600] : Colors.white
              ),
          ),
          

        ],

      ),
  );
  
  }
}

