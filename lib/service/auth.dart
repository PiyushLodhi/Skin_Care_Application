import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/service/database.dart';
import 'package:flutter/material.dart';
class AuthService
{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 User user1 ;


 //custom object
 User _userfromfirebaseuser(FirebaseUser user )
 {
   return user !=null?User(uid : user.uid):null;
 }

 //stream
 Stream<User> get user{
   return _auth.onAuthStateChanged.map(_userfromfirebaseuser);
 }

 Future signInAnon() async{
   try
   {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _userfromfirebaseuser(user);
   }catch(e)
   {
        print(e.toString());
        return null;
   }
 }

 Future signInWithEmailAndPassword(String email, String password) async {
   try {
     AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;
     user1=_userfromfirebaseuser(user);
     return user;
   } catch (error) {
     print(error.toString());
     return null;
   }
 }
 Future registerWithEmailAndPassword(String email, String password) async {
   try {
     AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
     FirebaseUser user = result.user;
     user1 = _userfromfirebaseuser(user);
     // create a new document for the user with the uid
     List <String>  e;
     List <String>  x=new List();
     String y= user.uid;
     x.add(y);
     //x.add('papppp');
     await DatabaseService(uid: user.uid).updateUserData('user',email,0, "Male","patient",x,0);
     return _userfromfirebaseuser(user);
   } catch (error) {
     print(error.toString());
     return null;
   }
 }



 //signout
 Future signOut() async {
   try {
     return await _auth.signOut();
   } catch (error) {
     print(error.toString());
     return null;
   }
 }
 void  inputData() async {
   final FirebaseUser user = await _auth.currentUser();
   user1 = _userfromfirebaseuser(user);
   print(user1.uid);

   // here you write the codes to input the data into firestore
 }
  Future jugad(String ui) async {
     final  documentReference = await Firestore.instance.collection('user profile').document(ui);
     return documentReference.get() ;
 }
List<DocumentSnapshot> getuser(User user)
 {
   List<DocumentSnapshot> usersList = new List(1);
   List<dynamic>brews = new List();
   int x=0;
   inputData();
   print("xdcfvghjklkjhgfdsasdfghjk,lkjhgfdsdfghjk,jhgfdsdfghjk");
   print(user.uid);
   dynamic documentReference = jugad(user.uid) ;
   //await  Firestore.instance.collection('user profile').document(user.uid);
   documentReference.get().then((datasnapshot) async {
     if (datasnapshot.exists) {
       brews = datasnapshot.data['contacts'];
       //usersList = List<datasnapshot.runtimeType>;
       print(brews.runtimeType);
       for (var ui in brews){
         print('reached');
         dynamic documentReference =jugad(ui) ;
          //await Firestore.instance.collection('user profile').document(user.uid);
         print(ui);
         documentReference.get().then((datasnapshot) async {
           if (datasnapshot.exists) {
             print('chutiyeeee');
             usersList[x] = datasnapshot;
             x++;
             print(usersList[x-1].data['id']);
           }
         });

       }
     }
   });
   print(usersList.length);
   return usersList;
 }
}