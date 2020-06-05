import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';

class ChillFavourite extends StatefulWidget {
  @override
  _ChillFavouriteState createState() => _ChillFavouriteState();
}

class _ChillFavouriteState extends State<ChillFavourite> {
  List<Chill> images = [];
  List<int> favorites = [];
  List<Chill> favoutiesImages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }

  getAll() async {
    await getChill();
    await getFavorites();
    getChillFavourites();
  }

  getChillFavourites() {
    setState(() {
      for (int i = 0; i < images.length; i++) {
        if (favorites.contains(images[i].image_id)) {
          favoutiesImages.add(images[i]);
        }
      }
    });
  }

  getChill() async {
    QuerySnapshot snapshot =
        await chillRef.orderBy("image_id", descending: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Chill album = Chill.fromDocument(doc);
      images.add(album);
      setState(() {
        images = images;
      });
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
        print('${f.data}}');
        setState(() {
          favorites = new List<int>.from(f.data['favourite']);
//                f.data['favourite'].cast<int>();
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
          children: List.generate(favoutiesImages.length, (index) {
            return Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
//
                    GestureDetector(
                        child: Container(
                          child:
                              Image.network(favoutiesImages[index].image_url),
                          width: 150,
                          height: 120,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  favoutiesImages[index].image_url,
                                ),
                              ));
                        }),
                    Row(
                      children: <Widget>[
                        Text(favoutiesImages[index].image_title),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favorites.remove(images[index].image_id);
                              addFavorite(favorites);
                              print(favorites.length);
                              setState(() {
                                images[index].isFavorite = false;
                                favoutiesImages.removeAt(index);
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
