
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:photo_view/photo_view.dart';


class AlbumFavourite extends StatefulWidget{
  @override
  _AlbumFavouriteState createState() => _AlbumFavouriteState();
}

class _AlbumFavouriteState extends State<AlbumFavourite> {
  List<Album> images=[];
  List<int>favorites=[];
List<Album>favoutiesImages=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();

  }
  getAll()async
  {
    await getAlbum();
    await getFavorites();
     getAlbumFavourites();
  }

  getAlbumFavourites()
  {
    setState(() {
      for(int i=0;i<images.length;i++)
        {
          if(favorites.contains(images[i].image_id) )
            {
              favoutiesImages.add(images[i]) ;

            }
        }
    });
  }


  getAlbum() async {
    QuerySnapshot snapshot = await albumRef
        .orderBy("image_id", descending: false)
        .getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Album album = Album.fromDocument(doc);
//      DocumentSnapshot favoriteImages = await userRef
//          .document(currentUser.id)
//          .collection("favoriteImages")
//          .document("${album.image_id}Log")
//          .get();
//      if (favoriteImages.exists) {
//        album.isFavorite = favoriteImages["isFavorite"];
//      } else {
//        album.isFavorite = false;
//      }
      images.add(album);
      setState(() {
        images = images;
      });
    });
  }
  addFavorite(List favourites) async{
    await userRef.document(currentUser.id)
        .collection("favourite_album")
        .document("fav")
        .setData({"favourite":favourites});


  }
  getFavorites() async
  {

    await userRef.document(currentUser.id)
        .collection("favourite_album")
        .getDocuments().then( (QuerySnapshot snapshot) {
      snapshot.documents.forEach((f)
      {print('${f.data}}');
      setState(() {
        favorites=new List<int>.from(f.data['favourite']);
//                f.data['favourite'].cast<int>();
      });
      });;
    }


    );
  }


  @override
  Widget build(BuildContext context) {
    bool isFavorite;
    // TODO: implement build
    return Scaffold(
      body: GridView.count(
          crossAxisCount: 2,
          children:List.generate(favoutiesImages.length, (index)
          {

            //بدل كده هجيب الليسته في الاول واساوي بيها
            return
              Card(
                  elevation: 10.0,
                  child:Column(children: <Widget>[
//
                    GestureDetector(child:
                    Container(child:
                    Image.network(favoutiesImages[index].image_url),width: 150,height: 120,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(favoutiesImages[index].image_url,),));

                        }
                    ),
                    Row(
                      children: <Widget>[
                        Text(favoutiesImages[index].image_title),
//                    Icon(Icons.favorite,color: Colors.grey,)
                        IconButton(icon:Icon(Icons.favorite,color: Colors.red,),
                          onPressed: () {

                            setState(() {

                                favorites.remove(images[index].image_id);
                                addFavorite(favorites);
                                print(favorites.length);
                                setState(() {
                                  images[index].isFavorite=false;
                                  favoutiesImages.removeAt(index);
                                });



                            });
                          },)
                      ], mainAxisAlignment: MainAxisAlignment.spaceAround,
                    )
                  ],
                  )

              );

          })
      ),
    );
  }
}
