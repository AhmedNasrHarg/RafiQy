import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttershare/pages/chillzone.dart';
import 'package:fluttershare/pages/sheets_entery_page.dart';
import 'package:fluttershare/pages/situation-details.dart';
import 'package:fluttershare/widgets/sheet_chat.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import 'home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
NotificationAppLaunchDetails notificationAppLaunchDetails;
GlobalKey _scaffold = GlobalKey();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class SituationGrid extends StatefulWidget {
  SituationGrid({Key key}) : super(key: key);

  @override
  DateGridState createState() => DateGridState();
}

class DateGridState extends State<SituationGrid> {
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: _time);
    setState(() {
      _time = picked;
      print(picked);
      _showDailyAtTime();
      _requestIOSPermissions();
      _configureDidReceiveLocalNotificationSubject();
      _configureSelectNotificationSubject();
    });
  }

  List<int> situations = [];
  BuildContext context2;

  Future<void> test() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  @override
  void initState() {
    super.initState();
    context2 = this.context;
    getdates();
    test();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
//    _configureSelectNotificationSubject();
  }

  Future onSelectNotification(String payload) async {
    print('jj');
    Navigator.push(
      context2,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: 'logSheet',
                sheetName: 'سِجِل الخواطر والمشاعر',
                deleteLast: true,
              )),
    );
    print('ppppp');
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print('jkkjj');
      await showDialog(
        context: context2,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context2, rootNavigator: true).pop();
                await Navigator.push(
                  context2,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      title: 'logSheet',
                      sheetName: 'سِجِل الخواطر والمشاعر',
                      deleteLast: true,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  Future<void> _configureSelectNotificationSubject() async {
    await selectNotificationSubject.stream.listen((String payload) async {
      print('iii');
      print('iiitttpppp');
      print('context $context');
      print('context2 $context2');
      print('context3 ${_scaffold.currentContext}');
      if (context2 != null) ;
      Navigator.push(
        context2,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: 'logSheet',
                  sheetName: 'سِجِل الخواطر والمشاعر',
                  deleteLast: true,
                )),
      );
    });
  }

  Future<void> _showDailyAtTime() async {
    var time = Time(picked.hour, picked.minute, 0);
    print(picked.hour);
    print(picked.minute);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Log Sheet Remainder',
        'Do not miss your sheet!',
        time,
        platformChannelSpecifics);
  }

  getdates() async {
    QuerySnapshot querySnapshot = await userRef
        .document(currentUser.id)
        .collection("logSheetOutput")
        .getDocuments();
    //     .then((value) {
    //  print(value.documents.first.documentID) ;
    //  value.documents.forEach((element) {situations.add(element.documentID as int); });
    // });
    setState(() {
      querySnapshot.documents.forEach((element) {
        situations.add(int.parse(element.documentID));
      });
    });
  }

  dateToArabic(now) async {
    await initializeDateFormatting("ar_EG", null);
    var formatter = Intl.DateFormat.yMMMMEEEEd('ar_EG');
    String formatted = formatter.format(now);
    return formatted;
  }

  dataCells() {
    List<Widget> widgets = [];
    for (var item in situations) {
      var card = GestureDetector(
        child: Card(
          color: Colors.lightBlue[50],
          child: FutureBuilder(
            future: dateToArabic(DateTime.fromMillisecondsSinceEpoch(item)),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Center(
                      child: Text(
                        snapshot.data,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : CircularProgressIndicator();
            },
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SituationDetails(
                        data: item,
                      )));
        },
      );
      widgets.add(card);
    }
    return widgets;
  }

  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
//    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() => context = this.context);
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text('جدول الرصد'),
        actions: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('إضافة'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: 'logSheet',
                          sheetName: 'سِجِل الخواطر والمشاعر',
                          deleteLast: true,
                        )),
              );
            },
            color: Colors.amber,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height / 2 - 25,
                  padding: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    children: dataCells(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    child: Center(
                        child: Text(
                      'أهمية جدول الرصد',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    child: Column(
                      children: <Widget>[
                        Text(
                          "كتابة الحدث بشكل مفصل و ما ارتبط به من مشاعر سلبية و إدراك ما وراءها من أفكار و ما نتج عن ذلك كله من سلوك و هي الطريق الممهد للأستبصار (gaining insight)، بها تعرف أثر مشاعرك السلبية (مثال: القلق)، المطلوب منك رصد كل حدث شعرت فيه بالقلق، شدته، و ما الأفكار التي كانت تدور في رأسك، و ما نتج عن ذلك القلق (السلوكيات التجنبية).\nاعتر جدول الرصد هو دفتر يومياتك تكتب فيه الاحداث التي تراها سيئة، كي تستطيع التعامل معاها او تعيد النظر فيها بعدما تتعلم (معرفيا و سلوكيا) كيفية التعامل مع القلق.\nملحوظة: هذه المهمة مفتوحة كدفتر يومياتك و يطلب منك الالتزام بجدول الرصد لمدة اسبوع ع الأقل قبل أن تفتح المهمة التالية.\nرفيقي يرغب في مساعدتك .. حدد لي من فضلك ساعة انبهك فيها لتكتب معي جدول اليوم.",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.access_alarm),
                            onPressed: () {
                              selectTime(context);
                            }),
                      ],
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
