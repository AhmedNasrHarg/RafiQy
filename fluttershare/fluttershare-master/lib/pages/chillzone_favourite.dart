import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'chillzone_grid.dart';

class ChillFavourite extends StatefulWidget {
  @override
  _ChillFavouriteState createState() => _ChillFavouriteState();
}

class _ChillFavouriteState extends State<ChillFavourite> {
  List<Chill> chillItems = [];
  List<int> favorites = [];
  List<Chill> favourietItems = [];
  int item=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    showSuggestionsDialog();
    getAll();
  }

  getAll() async {
    await getChill();
    await getFavorites();
    getChillFavourites();
  }

  getChillFavourites() {
    if(mounted) {
      setState(() {
        for (int i = 0; i < chillItems.length; i++) {
          if (favorites.contains(chillItems[i].item_id)) {
            favourietItems.add(chillItems[i]);
          }
        }
      });
    }
  }

  getChill() async {
    QuerySnapshot snapshot =
        await chillRef.orderBy("ch_id", descending: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Chill album = Chill.fromDocument(doc);
      chillItems.add(album);
      if(mounted)
        {
      setState(() {
        chillItems = chillItems;
      });}
    });

  }

  addFavorite(List favourites) async {
    await userRef
        .document(currentUser.id)
        .collection("favourite_chill")
        .document("fav")
        .setData({"favourite": favourites});
  }

  getFavorites() async {
    await userRef
        .document(currentUser.id)
        .collection("favourite_chill")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
//        print('${f.data}}');
        if(mounted) {
          setState(() {
            favorites = new List<int>.from(f.data['favourite']);
//                f.data['favourite'].cast<int>();
          });
        }
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
          childAspectRatio: (70/50),
          crossAxisCount: 1,
          children: List.generate(favourietItems.length, (index) {
            return Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
//
                    GestureDetector(
                        child: Container(
                          child:
                              Lottie.network(favourietItems[index].lottie),
                          width: 170,
                          height: 170,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  favourietItems[index].item_image,
                                ),
                              ));
                        }),
                    Row(
                      children: <Widget>[
                        Text(favourietItems[index].item_title),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favorites.remove(chillItems[index].item_id);
                              addFavorite(favorites);
//                              print(favorites.length);
                              setState(() {
                                chillItems[index].isFavorite = false;
                                favourietItems.removeAt(index);
                              });
                            });
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    )
                  ],
                ));
          })),

    );
  }

}
