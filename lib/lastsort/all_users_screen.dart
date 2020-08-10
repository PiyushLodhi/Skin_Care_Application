import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:skin_care_app/lastsort/chat_screen.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/home/home.dart';
import 'package:skin_care_app/service/auth.dart';
import 'package:skin_care_app/service/database.dart';

class AllUsersScreen extends StatefulWidget {
  User _user ;
  AllUsersScreen(User us){
    _user = us;
  }
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _aut = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> usersList;
  List<DocumentSnapshot> usersList2;
  final CollectionReference _collectionReference =
      Firestore.instance.collection("user profile");
  String dropdownValue = 'English';

  @override
  void initState() {
    super.initState();
    _subscription = _collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        usersList = datasnapshot.documents;
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
  Future<QuerySnapshot> cheker(recieverid)
  async {

    final FirebaseUser user = await _aut.currentUser();
    final userid = user.uid;
    QuerySnapshot x = await DatabaseService(uid: userid).checkreciever(recieverid);
    return x;

  }
  @override
  Widget build(BuildContext context) {
    List<dynamic> curren;

    return Scaffold(
        appBar: AppBar(
          title: Center(child : Text("Ask Doctor")),
          actions: <Widget>[
        DropdownButton<String>(
        value: dropdownValue,
          icon: Icon(Icons.language),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.amber),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['English','Hindi']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
          ],
        ),
        body: usersList != null
            ? Container(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: ((context, index) {
                    if(usersList[index].data['position']=="doctor" && usersList[index].data['contacts'].indexOf(widget._user.uid)!=-1 &&
                        usersList[index].data['id']!=widget._user.uid){return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(''),
                      ),
                      title: Text(usersList[index].data['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(usersList[index].data['email'],
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                      onTap: (() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    name: usersList[index].data['name'],
                                    photoUrl: '',
                                    receiverUid:
                                        usersList[index].data['id'],
                                    language:dropdownValue)
                            ));

                      }),
                    );}
                    else{return ListTile();}
                  }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
