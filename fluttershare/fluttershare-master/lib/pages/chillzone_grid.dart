import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/pages/chillInteractiveDetails.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:fluttershare/pages/video_details.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'chillLottie.dart';

class ChillGrid extends StatefulWidget {
  @override
  _ChillGridState createState() => _ChillGridState();
  ChillGrid();
}

class _ChillGridState extends State<ChillGrid> {
  List<Chill> chillItems = [];
  List<int> favorites = [];
  List<ChillUsed>numberOfUsedItem=[];
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }
  getAll()async
  {
   await getChill();
   await getFavorites();
   await getNumberUsed();
   addNumUsed();

  }

  getChill() async {
    print('chiiiiiiil');
    QuerySnapshot snapshot =
    await chillRef.orderBy("ch_id", descending: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Chill chill = Chill.fromDocument(doc);
      chillItems.add(chill);
      if(mounted) {
        setState(() {
          chillItems = chillItems;
        });
      }
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

  increaseCounter(Chill itemUsed)async
  {
    await userRef.document(currentUser.id).collection("number_used_chill")
        .document("${itemUsed.item_id}").setData({"num_used":itemUsed.numUsed,"ch_id":itemUsed.item_id});
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
        if(mounted) {
          setState(() {
            favorites = new List<int>.from(f.data['favourite']);
          });
        }
      });
      ;
    });
  }
  
  getNumberUsed()async
  {
    await userRef
        .document(currentUser.id)
        .collection("number_used_chill")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        
        numberOfUsedItem.add(ChillUsed.fromDocument(f));
        print("number used${f["num_used"]}");
        if(mounted) {
          setState(() {
            numberOfUsedItem = numberOfUsedItem;
          });
        }
      });
      ;
    });


    
  }
  addNumUsed()
  {
    for(int i=0;i<numberOfUsedItem.length;i++)
    {
      for(int j=0;j<chillItems.length;j++)
      {
        if(numberOfUsedItem[i].ch_id==chillItems[j].item_id)
        {
          chillItems[j].numUsed=numberOfUsedItem[i].ch_num_used;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite;
//    bool numUseId;
    // TODO: implement build
    return Scaffold(
      body: GridView.count(
          childAspectRatio: (70 / 50),
          crossAxisCount: 1,
          children: List.generate(
              chillItems.length, (index) {
            isFavorite = favorites.contains(chillItems[index].item_id);
//            numUseId=numberOfUsedItem.contains(chillItems[index].item_id);
            return Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
//
                    GestureDetector(
                        child: Container(
//                          child: Lottie.network(images[index].lottie),
                          child: Lottie.network(chillItems[index].lottie),
                          width: 150,
                          height: 150,
                        ),
                        onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                builder: (context) => ImageViewer(
//                                  shillItems[index].item_image,
//                                ),
//                              ));
                        if(index==0)
                          {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChillLottie(
                                 lottieUrl: chillItems[index].lottie,
                                ),
                              ));
                          }
                        else if(index%2==0&&index!=0)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>VideoPlay(itemChill: chillItems[index])
                                ));

                          }
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChillInteractiveDetails(itemChill: chillItems[index],)
                              ));
                        }

                        }),
                    Row(
                      children: <Widget>[
                        Text(chillItems[index].item_title, style: TextStyle(
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
                                favorites.contains(chillItems[index].item_id);
                            print(isFavorite);
                            setState(() {
                              if (isFavorite) {
                                print("ifffff");
                                favorites.remove(chillItems[index].item_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  chillItems[index].isFavorite = false;
                                });
                              } else {
                                print("elssssssee");
                                favorites.add(chillItems[index].item_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  chillItems[index].isFavorite = true;
                                });
                              }
                            });
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                    Container(
                      height: 1,
                      child: Ink(color: Colors.teal[800],),
                    ),
                    Row(
                      children: <Widget>[
                        Text("عدد الاستخدمات"),
                        Text(chillItems[index].numUsed.toString(), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal),),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(
                          icon: 
                               Icon(
                            Icons.add,
                            color: Colors.teal,
                            size: 30,
                          )
                              ,
                          onPressed: () {
                            setState(() {
                              chillItems[index].numUsed++;
                              increaseCounter(chillItems[index]);
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
//        floatingActionButton: FloatingActionButton(
//          backgroundColor:Colors.teal,
//          onPressed: () {
//            showSuggestionsDialog();
//
//          },
//          child: Column(children:<Widget>[
//            Icon(Icons.mood,color: Colors.white,)
//            ,Text("اقترح",style: TextStyle(color: Colors.white),)
//          ],),
//        )
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
class ChillUsed
{
  int ch_id;
  int ch_num_used;
  ChillUsed({this.ch_id,this.ch_num_used});
  factory ChillUsed.fromDocument(DocumentSnapshot doc) {
    return ChillUsed(
        ch_id: doc["ch_id"],
        ch_num_used:doc["num_used"]
    );
  }
}