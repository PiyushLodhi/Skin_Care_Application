import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_care_app/chate/chat_screen.dart';
import 'package:skin_care_app/chate/main.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/service/auth.dart';

class AllUsersScreen extends StatefulWidget {
   User _user ;
  AllUsersScreen(User us){
    _user = us;
  }
  _AllUsersScreenState createState() => _AllUsersScreenState(_user);
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  //final GoogleSignIn googleSignIn = GoogleSignIn();
  User user ;
  _AllUsersScreenState(User us) {
    user = us;
  }
  //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> usersList = new List();
  final CollectionReference _collectionReference =
      Firestore.instance.collection("user profile ");

  @override
  void initState() {
    super.initState();
    _subscription = _collectionReference.snapshots().listen((datasnapshot1) {
      setState(() {
        usersList =  AuthService().getuser(user);//datasnapshot1.documents;
    Future.delayed(Duration(seconds:3));
        print("Users List ${usersList.length}");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
   // _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print(usersList.length);
    return Scaffold(
        appBar: AppBar(
          title: Text("All Users"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //await firebaseAuth.signOut();
                //await googleSignIn.disconnect();
                //await googleSignIn.signOut();
                print("Signed Out");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
        body: usersList != null
            ? Container(
                child: ListView.builder(
                  itemCount: 1,//usersList.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('www.google.com'),
                      ),
                      title: Text(usersList[index].data['id'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(usersList[index].data['position'],
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                      onTap: (() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    name: usersList[index].data['name'],
                                    photoUrl: 'www.google.com',
                                    receiverUid:
                                        usersList[index].data['id'])));
                      }),
                    );
                  }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
