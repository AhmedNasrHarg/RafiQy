import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import '../pages/create_account.dart';
import '../pages/home.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(BuildContext context, String email, String password);
  Future<String> signInWithGoogle();
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user!=null){
       await setCurrentUser(user.uid);
    }
    return user;
  }


  @override
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    await setCurrentUser(user.uid);
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(
      BuildContext context, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    String username = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAccount()));
    await createUserInFirestore(user.uid, email, username);
    await setCurrentUser(user.uid);
    return user.uid;
  }

  createUserInFirestore(userId, email, userName) async {
    DocumentSnapshot doc = await userRef.document(userId).get();
    if (!doc.exists) {
      userRef.document(userId).setData({
        "id": userId,
        "username": userName,
        "email": email,
        "photoUrl":
            "https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png",
        "bio": "",
        "timestamp": DateTime.now(),
        "isAdmin": false,
      });
    }
  }

  setCurrentUser(userId) async {
    DocumentSnapshot doc = await userRef.document(userId).get();
    currentUser = User.fromDocument(doc);
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    DocumentSnapshot doc = await userRef.document(user.uid).get();
    if (!doc.exists) {
      await userRef.document(user.uid).setData({
        "id": user.uid,
        "username": user.displayName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": DateTime.now(),
        "isAdmin": false,
      });
    }
    await setCurrentUser(user.uid);
    return user.uid;
  }

}
