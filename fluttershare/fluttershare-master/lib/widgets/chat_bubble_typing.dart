import 'package:flutter/material.dart';

class BubbleTyping extends StatefulWidget {
  BubbleTyping({Key key}) : super(key: key);

  @override
  _BubbleTypingState createState() => _BubbleTypingState();
}

class _BubbleTypingState extends State<BubbleTyping>
with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;
  @override
  void initState() { 
    super.initState();
    animController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animController.forward();
      }
    });

    animController.forward();
  }
  @override
  void dispose() { 
    animController.dispose();
    
    super.dispose();
  }
  final dot = Container(
    width: 10,
    height: 10,
    decoration: new BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );


  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: opacityDots(),
    );
  }

  Widget opacityDots(){
    return AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: Row(
          children: <Widget>[
            dot,
            SizedBox(
              width: 3,
            ),
            dot,
            SizedBox(
              width: 3,
            ),
            dot,
            SizedBox(
              width: 3,
            ),
          ],
        ),
      );
  }

  Widget movingDots(){
    return Transform.translate(
        offset: Offset(0, animation.value),
        child: Row(
          children: <Widget>[
            dot,
            SizedBox(
              width: 3,
            ),
            dot,
            SizedBox(
              width: 3,
            ),
            dot,
            SizedBox(
              width: 3,
            ),
          ],
        ),
      );
  }
}
