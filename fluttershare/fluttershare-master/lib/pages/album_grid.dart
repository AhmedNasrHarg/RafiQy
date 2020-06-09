
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';


class AlbumGrid extends StatefulWidget{
  @override
  _AlbumGridState createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> {
List<Album> images=[];
List<int>favorites=[];
//Set<Album>favourites=Set<Album>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlbum();
    getFavorites();
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
      children:List.generate(images.length, (index)
      {
        isFavorite=favorites.contains(images[index].image_id);

        //بدل كده هجيب الليسته في الاول واساوي بيها
            return
            Card(
                elevation: 10.0,
                child:Column(children: <Widget>[
//
                  GestureDetector(child:
                  Container(child:
                  Image.network(images[index].image_url),width: 150,height: 120,),
        onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(images[index].image_url,),));

      }
                  ),
                  FittedBox(child: Row(
                    children: <Widget>[
                      Text(images[index].image_title),
//                    Icon(Icons.favorite,color: Colors.grey,)
                      IconButton(icon:isFavorite?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border),color: Colors.grey,
                        onPressed: () {
                          isFavorite=favorites.contains(images[index].image_id);
                          print(isFavorite);

                          setState(() {
                            if(isFavorite)
                            {
                              print("ifffff");
                              favorites.remove(images[index].image_id);
//                            for(int i;i<favorites.length;i++)
//                              {
//                                print(favorites[i]);
//                              }
                              addFavorite(favorites);
                              print(favorites.length);
                              setState(() {
                                images[index].isFavorite=false;
                              });
                            }
                            else{
                              print("elssssssee");
                              favorites.add(images[index].image_id);
                              addFavorite(favorites);
                              print(favorites.length);
                              setState(() {
                                images[index].isFavorite=true;
                              });

                            }

                          });
                        },)
                    ], mainAxisAlignment: MainAxisAlignment.spaceAround,
                  )),

                ],
                )
                
            );

      })
      ),
      );
  }

}
