import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';

class ChillGrid extends StatefulWidget {
  @override
  _ChillGridState createState() => _ChillGridState();
}

class _ChillGridState extends State<ChillGrid> {
  List<Chill> images = [];
  List<int> favorites = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChill();
    getFavorites();
  }

  getChill() async {
    QuerySnapshot snapshot =
        await chillRef.orderBy("image_id", descending: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Chill chill = Chill.fromDocument(doc);
      images.add(chill);
      setState(() {
        images = images;
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
          crossAxisCount: 2,
          children: List.generate(images.length, (index) {
            isFavorite = favorites.contains(images[index].image_id);

            return Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
//
                    GestureDetector(
                        child: Container(
                          child: Image.network(images[index].image_url),
                          width: 150,
                          height: 120,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  images[index].image_url,
                                ),
                              ));
                        }),
                    Row(
                      children: <Widget>[
                        Text(images[index].image_title),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(
                          icon: isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border),
                          color: Colors.grey,
                          onPressed: () {
                            isFavorite =
                                favorites.contains(images[index].image_id);
                            print(isFavorite);
                            setState(() {
                              if (isFavorite) {
                                print("ifffff");
                                favorites.remove(images[index].image_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  images[index].isFavorite = false;
                                });
                              } else {
                                print("elssssssee");
                                favorites.add(images[index].image_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  images[index].isFavorite = true;
                                });
                              }
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
