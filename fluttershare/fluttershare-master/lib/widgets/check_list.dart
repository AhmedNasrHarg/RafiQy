import 'package:flutter/material.dart';
import 'package:fluttershare/models/check_list_item.dart';

List<CheckListItem> checkedItems =[];


checkList({List<CheckListItem> items}){
  List<Widget> widgests = [];
  items.forEach((element) {
    widgests.add(Item(item: element));
  });
  return Column(
    children: widgests,
  );
}

class Item extends StatefulWidget {

  final CheckListItem item;
  Item({this.item});

  @override
  _ItemState createState() => _ItemState(item: this.item);


}

class _ItemState extends State<Item> {

  final CheckListItem item;
  bool isChecked = false;

  @override
  void initState() { 
    super.initState();
    checkedItems.clear();
  }

  _ItemState({this.item});

  handleCheck(){
    setState(() {
      isChecked = !isChecked;
    });
    if(isChecked){
      checkedItems.add(item);
    }
    else{
      checkedItems.remove(item);
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
    item.name,
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

