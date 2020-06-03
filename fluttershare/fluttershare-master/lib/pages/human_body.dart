import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/check_list_item.dart';
import 'package:fluttershare/pages/home.dart';

var otherSymp = [];
var moreSymp = '';
// <CheckListItem>[
//   CheckListItem(name: 'صداع بالرأس', type: 'الدماغ'),
//   CheckListItem(name: 'زيادة معدل ضربات القلب', type: 'القلب'),
//   CheckListItem(name: 'ضيق فى التنفس، آلام صدرية', type: 'الصدر'),
//   CheckListItem(
//       name: 'التعرق الشديد',
//       type: 'اخري',
//       media: 'https://media.giphy.com/media/3oEduKby3KcdAqEUVO/giphy.gif'),
//   CheckListItem(
//       name: 'الإرتجاف (الرعشة)',
//       type: 'اخري',
//       media: 'https://media.giphy.com/media/3o6MbiezBUp7pXNMVG/giphy.gif'),
//   CheckListItem(
//       name: 'فرط النوم',
//       type: 'اخري',
//       media: 'https://media.giphy.com/media/up8gI8DCcdd1S/giphy.gif'),
//   CheckListItem(name: 'مشكلات معدية', type: 'المعدة'),
//   //CheckListItem(name: 'تشوش الرؤية', type: 'العين'),
//   CheckListItem(name: 'دوار', type: 'الدماغ'),
// ];

class HumanBody extends StatefulWidget {
  HumanBody({Key key}) : super(key: key);
  @override
  HumanBodyState createState() => HumanBodyState();
}

class HumanBodyState extends State<HumanBody> {
  var brainClicked = false;
  var lungsClicked = false;
  var heartClicked = false;
  var stomachClicked = false;
  var eyesClicked = false;
  List<CheckListItem> symptoms = [];
  @override
  void initState() {
    getSyptoms();
    super.initState();
  }

  getSyptoms() async {
    List<CheckListItem> items = [];
    String str = '';
    DocumentSnapshot documentSnapshot = await userRef
        .document(currentUser.id)
        .collection("completedSheets")
        .document('bodyResponseSheetLog')
        .get();
    if(documentSnapshot['answer7'] != null){
     documentSnapshot['answer7'].forEach((e){
        if(e.toString().compareTo('تم') != 0){
          str += e.toString() + '\n';
        }
      });
    }
    documentSnapshot['answer6'].forEach((element) {
      var q = Map<String, dynamic>.from(element);
      CheckListItem qst = CheckListItem.fromJson(q);
      if (qst.type.compareTo('اخري') == 0)
        items.add(qst);
      else
        symptoms.add(qst);
    });
    setState(() {
      otherSymp = items;
      moreSymp = str;
    });
  }

  sympWidgets(String title, List<CheckListItem> symp) {
    List<Widget> widgets = [];
    for (var item in symp) {
      if (item.type.compareTo(title) == 0)
        widgets.add(Text(
          item.name,
          textDirection: TextDirection.rtl,
        ));
    }
    return widgets;
  }

  showSnackBar(String title, List<CheckListItem> symp) {
    return SnackBar(
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListBody(
          children: sympWidgets(title, symp),
          mainAxis: Axis.vertical,
        ),
      ),
    );
  }

  showMyDialog(String title, List<CheckListItem> symp) {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title+':',
            textDirection: TextDirection.rtl,
          ),
          content:sympWidgets(title, symp).isEmpty? Text('لا يوجد أعراض'): SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: sympWidgets(title, symp),
              mainAxis: Axis.vertical,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(symptoms.length);
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: orientation == Orientation.portrait ? 712 : 392,
                child: Center(
                  child: Stack(
                    // fit: StackFit.loose,
                    children: <Widget>[
                      Center(child: Image.asset('assets/images/body.png')),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    brainClicked = !brainClicked;
                                    lungsClicked = heartClicked =
                                        stomachClicked = eyesClicked = false;
                                    brainClicked
                                        ? showMyDialog('الدماغ', symptoms)
                                        : null;
                                  });
                                },
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: brainClicked ? 1 : 0.3,
                                  child: Image.asset(
                                    'assets/images/brain.png',
                                    width: orientation == Orientation.portrait
                                        ? 50
                                        : 30,
                                    height: orientation == Orientation.portrait
                                        ? 40
                                        : 20,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    eyesClicked = !eyesClicked;
                                    lungsClicked = heartClicked =
                                        stomachClicked = brainClicked = false;
                                    eyesClicked
                                        ? showMyDialog('العين', symptoms)
                                        : null;
                                  });
                                },
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: eyesClicked ? 1 : 0.3,
                                  child: Image.asset(
                                    'assets/images/eyes1.png',
                                    width: orientation == Orientation.portrait
                                        ? 50
                                        : 25,
                                    height: orientation == Orientation.portrait
                                        ? 20
                                        : 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: orientation == Orientation.portrait
                                    ? 40
                                    : 20,
                              ),
                              Stack(
                                fit: StackFit.loose,
                                children: <Widget>[
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          lungsClicked = !lungsClicked;
                                          brainClicked = heartClicked =
                                              eyesClicked =
                                                  stomachClicked = false;
                                          lungsClicked
                                              ? showMyDialog('الصدر', symptoms)
                                              : null;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: lungsClicked ? 1 : 0.3,
                                        child: Image.asset(
                                          'assets/images/lungs.png',
                                          width: orientation ==
                                                  Orientation.portrait
                                              ? 100
                                              : 60,
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? 100
                                              : 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? 40
                                              : 25,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              heartClicked = !heartClicked;
                                              lungsClicked = brainClicked =
                                                  eyesClicked =
                                                      stomachClicked = false;
                                              heartClicked
                                                  ? showMyDialog(
                                                      'القلب', symptoms)
                                                  : null;
                                            });
                                          },
                                          child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 500),
                                            opacity: heartClicked ? 1 : 0.3,
                                            child: Image.asset(
                                              'assets/images/heart.png',
                                              width: orientation ==
                                                      Orientation.portrait
                                                  ? 40
                                                  : 25,
                                              height: orientation ==
                                                      Orientation.portrait
                                                  ? 40
                                                  : 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    stomachClicked = !stomachClicked;
                                    lungsClicked = heartClicked =
                                        eyesClicked = brainClicked = false;
                                    stomachClicked
                                        ? showMyDialog('المعدة', symptoms)
                                        : null;
                                  });
                                },
                                child: AnimatedOpacity(
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 500),
                                  opacity: stomachClicked ? 1 : 0.3,
                                  child: Image.asset(
                                    'assets/images/stomach.png',
                                    width: orientation == Orientation.portrait
                                        ? 100
                                        : 50,
                                    height: orientation == Orientation.portrait
                                        ? 100
                                        : 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Center(
                      child: Text(
                    'أعراض أخرى',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Colors.amber,
                      )),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: (otherSymp.isNotEmpty || moreSymp.isNotEmpty) ? CompilcatedImageDemo():Center(child: Text("لا يوجد أعراض أخري")),
                ),
              ),
              Center(
                child: Container(
                  child: Center(
                      child: Text(
                    'ماذا تعلمت؟',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Colors.amber,
                      )),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    'الإستجابة الجسدية للقلق هي بمثابة جرس إنذار، جسدك يخبرك انه في حاجة لتدخلك .. غير أن جسدك لا يميز درجة الخطورة، هذه مهمة فصك الأمامي، في انتباهك للأعراض الجسدية الخاصة بك تستطيع القاط شعور القلق منذ بدايته، تسميته و محاولة التعامل معه مبكرا، فتتحكم فيه قبل أن يتحكم فيك.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Colors.amber,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompilcatedImageDemo extends StatelessWidget {
  gifWidgets() {
   // print(symptoms.length);
    List<Widget> widgets = [];
    var moreSym = Card(
      color: Colors.amber[100],
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Center(
                child: Text("المزيد"),
              ),
              AutoSizeText(
                moreSymp,
                style: TextStyle(fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
    for (var item in otherSymp) {
      if (item.type.compareTo('اخري') == 0)
        widgets.add(Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item.media, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          // "${imgList.indexOf(item)}",
                          item.name,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
    }
    if(moreSymp.isNotEmpty)
    widgets.add(moreSym);
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: gifWidgets(),
        ),
      ],
    ));
  }
}
