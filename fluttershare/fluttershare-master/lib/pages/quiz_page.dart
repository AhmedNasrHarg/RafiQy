import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttershare/pages/quiz_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class QuziPage extends StatefulWidget {
  @override
  _QuziPageState createState() => _QuziPageState();
}

class _QuziPageState extends State<QuziPage> {
  SwiperController swiperController;
  bool selected0;
  bool selected1;
  bool selected2;
  bool selected3;
  int value;
  int sum;
  int i;
  @override
  void initState() {
    swiperController = new SwiperController();
    selected0 = false;
    selected1 = false;
    selected2 = false;
    selected3 = false;
    value = -1;
    sum = 0;
    i = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
// backgroundColor: ThemeData,
      appBar: new AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width - 50,
                child: Stack(
                  fit: StackFit.loose,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      color: Colors.grey[50],
                      margin: EdgeInsets.all(0),
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height - 200,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Swiper(
                          onIndexChanged: (value) => i = value,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 65,
                                ),
                                Text(
                                  "ما مدى تكرار انزعاجك من أي مشكلة من المشكلات التالية خلال الأسابيع الأربعة الأخيرة؟",
                                  style: TextStyle(
                                      color: Colors.indigo[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Text(
                                  qustions[index] + ':',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0xffE4F0FE), width: 2),
                                        color: selected0
                                            ? Color(0xffFCA82F)
                                            : Colors.white),
                                    child: Row(
                                      children: <Widget>[
                                        selected0
                                            ? Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.white,
                                              )
                                            : SizedBox(width: 8),
                                        SizedBox(width: 8),
                                        Text(
                                          "أبداً",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: selected0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected0 = true;
                                      selected1 = false;
                                      selected2 = false;
                                      selected3 = false;
                                      value = 0;
                                      print(i);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0xffE4F0FE), width: 2),
                                        color: selected1
                                            ? Color(0xffFCA82F)
                                            : Colors.white),
                                    child: Row(
                                      children: <Widget>[
                                        selected1
                                            ? Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.white,
                                              )
                                            : SizedBox(width: 8),
                                        SizedBox(width: 8),
                                        Text(
                                          "عدة ايام",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: selected1
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected0 = false;
                                      selected1 = true;
                                      selected2 = false;
                                      selected3 = false;
                                      value = 1;
                                      // print(value);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0xffE4F0FE), width: 2),
                                        color: selected2
                                            ? Color(0xffFCA82F)
                                            : Colors.white),
                                    child: Row(
                                      children: <Widget>[
                                        selected2
                                            ? Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.white,
                                              )
                                            : SizedBox(width: 8),
                                        SizedBox(width: 8),
                                        Text(
                                          "اكثر من نصف الايام",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: selected2
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected0 = false;
                                      selected1 = false;
                                      selected2 = true;
                                      selected3 = false;
                                      value = 2;
                                      // print(value);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0xffE4F0FE), width: 2),
                                        color: selected3
                                            ? Color(0xffFCA82F)
                                            : Colors.white),
                                    child: Row(
                                      children: <Widget>[
                                        selected3
                                            ? Icon(
                                                Icons.sentiment_very_dissatisfied,
                                                color: Colors.white,
                                              )
                                            : SizedBox(width: 8),
                                        SizedBox(width: 8),
                                        Text(
                                          "كل يوم تقريبا",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: selected3
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected0 = false;
                                      selected1 = false;
                                      selected2 = false;
                                      selected3 = true;
                                      value = 3;
                                      // print(value);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                              ],
                            );
                          },
                          itemCount: 7,
                          physics: NeverScrollableScrollPhysics(),
                          duration: 500,
                          pagination: SwiperPagination(
                              builder: SwiperPagination.dots,
                              alignment: Alignment.bottomLeft),
                          controller: swiperController,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: MaterialButton(
                        child: Text(
                          i != 6 ? "التالي" : "أنتهيت",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        color: Color(0xffFCA82F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          side: BorderSide(color: Color(0xffFED69D), width: 4),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        onPressed: () {
                          if (value != -1) {
                            if (i != 6) {
                              sum += value;
                              selected0 = false;
                              selected1 = false;
                              selected2 = false;
                              selected3 = false;
                              value = -1;
                              swiperController.next(animation: true);
                            } else {
                              sum += value;
                              print(sum);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuizResult(score:sum)));
                            }
                            setState(() {});
                          } else {
                            Fluttertoast.showToast(
                              msg: "أختار اجابة من فضلك",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                        top: -110,
                        left: -10,
                        child: Lottie.network(
                            'https://assets4.lottiefiles.com/packages/lf20_bmkCIy.json',
                            width: 200,
                            height: 200)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  List <QuizQuestion>quiz=[new QuizQuestion()]
  List<String> qustions = [
    " الشعور بالتوتر، العصبية أو القلق ",
    "عدم القدرة على ايقاف قلقك وهمومك او السيطرة عليها",
    "القلق و الهم الزائد حول عدة أمور",
    "صعوبة في الاسترخاء",
    "الشعور بعدم الاستقرار لدرجة تصعب عليك فيها الجلوس بلا حركة",
    "الانفعال أو الانزعاج بسهولة",
    "الشعور بالخوف وكأن شيء مريع قد يحدث لك"
  ];
}
