import 'package:flutter/material.dart';

List<String> checkedItems =[];


checkList({List<dynamic> items}){
  List<Widget> widgests = [];
  items.forEach((element) {
    widgests.add(Item(text: element.toString()));
  });
  return Column(
    children: widgests,
  );
}

class Item extends StatefulWidget {

  final String text;
  Item({this.text});

  @override
  _ItemState createState() => _ItemState(text: this.text);


}

class _ItemState extends State<Item> {

  final String text;
  bool isChecked = false;

  @override
  void initState() { 
    super.initState();
    checkedItems.clear();
  }

  _ItemState({this.text});

  handleCheck(){
    setState(() {
      isChecked = !isChecked;
    });
    if(isChecked){
      checkedItems.add(text);
    }
    else{
      checkedItems.remove(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
    
    child: isChecked ? Icon(Icons.check_box,color: Colors.amber,) : Icon(Icons.check_box_outline_blank, color: Colors.white,),
    onTap: () => handleCheck(),
        ),
      ),
      Text(
    text,
    maxLines: 2,
    style: TextStyle(
      fontSize: 15.0,
      color: Colors.white,
      decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none
    ),
        )
    ],
        );
  }
}

