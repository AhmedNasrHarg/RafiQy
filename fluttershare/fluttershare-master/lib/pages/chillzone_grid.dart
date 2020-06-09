import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'chillLottie.dart';

class ChillGrid extends StatefulWidget {
  @override
  _ChillGridState createState() => _ChillGridState();
  ChillGrid();
}

class _ChillGridState extends State<ChillGrid> {
  List<Chill> shillItems = [];
  List<int> favorites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChill();
    getFavorites();
  }

  getChill() async {
    print('chiiiiiiil');
    QuerySnapshot snapshot =
    await chillRef.orderBy("ch_id", descending: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Chill chill = Chill.fromDocument(doc);
      shillItems.add(chill);
      setState(() {
        shillItems = shillItems;
      });
    });
  }

  //done
  addFavorite(List favourites) async {
    await userRef
        .document(currentUser.id)
        .collection("favourite_chill")
        .document("fav")
        .setData({"favourite": favourites});
  }

  //done
  getFavorites() async {
    await userRef
        .document(currentUser.id)
        .collection("favourite_chill")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('${f.data}}');
        setState(() {
          favorites = new List<int>.from(f.data['favourite']);
        });
      });
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite;
    // TODO: implement build
    return Scaffold(
      body: GridView.count(
          childAspectRatio: (70 / 50),
          crossAxisCount: 1,
          children: List.generate(
              shillItems.length, (index) {
            isFavorite = favorites.contains(shillItems[index].item_id);

            return Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
//
                    GestureDetector(
                        child: Container(
//                          child: Lottie.network(images[index].lottie),
                          child: Lottie.network(shillItems[index].lottie),
                          width: 170,
                          height: 170,
                        ),
                        onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                builder: (context) => ImageViewer(
//                                  shillItems[index].item_image,
//                                ),
//                              ));

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChillLottie(
                                 lottieUrl: shillItems[index].lottie,
                                ),
                              ));

                        }),
                    Row(
                      children: <Widget>[
                        Text(shillItems[index].item_title, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal),),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(
                          icon: isFavorite
                              ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                              : Icon(Icons.favorite_border),
                          color: Colors.grey,
                          iconSize: 30,
                          onPressed: () {
                            isFavorite =
                                favorites.contains(shillItems[index].item_id);
                            print(isFavorite);
                            setState(() {
                              if (isFavorite) {
                                print("ifffff");
                                favorites.remove(shillItems[index].item_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  shillItems[index].isFavorite = false;
                                });
                              } else {
                                print("elssssssee");
                                favorites.add(shillItems[index].item_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  shillItems[index].isFavorite = true;
                                });
                              }
                            });
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    )
                  ],
                )
            );
          })),
        floatingActionButton: FloatingActionButton(
          backgroundColor:Colors.teal,
          onPressed: () {
            showSuggestionsDialog();

          },
          child: Column(children:<Widget>[
            Icon(Icons.mood,color: Colors.white,)
            ,Text("اقترح",style: TextStyle(color: Colors.white),)
          ],),
        )
    );
  }

  showSuggestionsDialog()
  {
    if(favorites.isEmpty)
    {
      Alert(
          context: context,
          title: "ليس لديك أية مفضلات",
          content: Container(
            height: 300,
            width: 350,
            child: Column(
              children: <Widget>[
                Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_EvfyyO.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                //animate to the next
              },
              child: Text("اظهر القائمة"),
            )
          ]).show();
    }
    else
    {

//      Alert(
//          context: context,
//          title: "مقترحات ",
//          content: Container(
//            height: 300,
//            width: 350,
//            child: Column(
//              children: <Widget>[
//                Image.network(
//                  favorites[item].item_image,
//                  width: 300,
//                  height: 300,
//                  fit: BoxFit.fill,
//                ),
//              ],
//            ),
//          ),
//          buttons: [
//            DialogButton(
//              onPressed: () {
//                Navigator.pop(context);
//                //animate to the next
//              },
//              child: Text("سأختر بنفسي"),
//            ),
//            DialogButton(
//              onPressed: ()
//              {
//
////                setState(() {
////                  item+1;
////                });
//                Navigator.pop(context);
//                showSuggestionsDialog();
//              },
//              child: Text(" شيء آخر"),
//            ),
//            DialogButton(
//              onPressed: ()
//              {
//                Navigator.pop(context);
//
//              },
//              child: Text("حسنا"),
//            )
//          ]).show();
    }
  }

}