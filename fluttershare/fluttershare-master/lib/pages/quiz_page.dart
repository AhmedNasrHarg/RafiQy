import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttershare/models/quiz.dart';

class QuziPage extends StatefulWidget {
  @override
  _QuziPageState createState() => _QuziPageState();
}

class _QuziPageState extends State<QuziPage> {
  SwiperController swiperController;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
     swiperController=new SwiperController();

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("qustions",
      )),
      body:
      Container(
        height: 500,
        width:400,
        child: Column(
          children:<Widget>[
            Container(
              height:400,
              child: new Swiper(

                itemBuilder: (BuildContext context,int index){
                  return
//              Container(child: MaterialButton(child:Text("next"),onPressed:(){
//                index+=1;
//                swiperController.move(index,animation: true);
//
//              },),);
                  Column(children: <Widget>[
                    Text("ما مدى تكرار انزعاجك من أي مشكلة من المشكلات التالية خلال الأسابيع الأربعة الأخيرة؟"),
                  Text(qustions[index]),
                    GestureDetector(child: Card(child: Text("ابدا")),onTap: ()
                      {

                      },),

                    Card(child: Text("عدة ايام"),),
                    Card(child: Text("اكثر من نصف الايام "),),
                    Card(child: Text("كل يوم تقريبا"),),

                  ],);
                },
                itemCount: 7,
                pagination: new SwiperPagination(builder: SwiperPagination.fraction),
//        control: new (),
//physics: NeverScrollableScrollPhysics(),
                controller:swiperController ,
              ),
            ),
            MaterialButton(child:Text("next"),onPressed:(){
              swiperController.next(animation: true);

            },),
          ]
        ),
      ),
    );
  }
//  List <QuizQuestion>quiz=[new QuizQuestion()]
List <String> qustions=[" الشعور بالتوتر، العصبية أو القلق ",
  "عدم القدرة على ايقاف قلقك وهمومك او السيطرة عليها.",
  " القلق و الهم الزائد حول عدة أمور",
  " صعوبة في الاسترخاء.",
  "الشعور بعدم الاستقرار لدرجة تصعب عليك فيها الجلوس بلا حركة",
  "الانفعال أو الانزعاج بسهولة.",
  "الشعور بالخوف وكأن شيء مريع قد يحدث لك."];
}
