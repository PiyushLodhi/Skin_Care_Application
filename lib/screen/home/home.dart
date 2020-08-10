
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skin_care_app/lastsort/all_users_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/home/drawermen.dart';
import 'package:skin_care_app/screen/home/profile_form.dart';
import 'package:skin_care_app/service/auth.dart';
import 'package:skin_care_app/service/database.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
class Home extends StatefulWidget {
  @override
  _MyAppState1 createState() => _MyAppState1();
}

class _MyAppState1 extends State<Home> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _aut = FirebaseAuth.instance;
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return StreamProvider<QuerySnapshot>.value(value:DatabaseService().brews,child:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        ),);
      });
    }
    final user = Provider.of<User>(context);
    return StreamProvider<QuerySnapshot>.value(value:DatabaseService().brews,
    child :Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children : <Widget>[
            DrawerHeader(
        margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:  AssetImage('assets/drawerimg.jpg'))),
            child: Stack(children: <Widget>[
              Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Skin Care Application",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500))),
            ])),
            ListTile(
            leading:Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 20),),
            onTap: _showSettingsPanel,),
            ListTile(
              leading:Icon(Icons.account_circle),
              title: Text('Logout',style: TextStyle(fontSize: 20),),
              onTap: ()async {
                await _auth.signOut();
              },)
          ],
        ),
      ),
      body:ListView(
    children :<Widget>[_loading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Image(image:AssetImage('assets/doctor-icon-16.jpg'),width: 300,height: 300) : Image.file(_image,width: 400,height: 400,),
            SizedBox(
              height: 40,
            ),
            _outputs != null
                ? Text(
              "${_outputs[0]["label"]}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                background: Paint()
                  ..color = Colors.white,
              ),
            )
                : Container(),

          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children : <Widget>[
          RaisedButton(
          onPressed: pickImage,
    child: Text('Image Upload'),
    color: Colors.lightBlue,
    ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllUsersScreen(user)),
                );
              },
              child: Text('Doctor Consultant'),
              color: Colors.lightBlue,
            ),
          ]
      ),
    ]),
    ));
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });


    classifyImage(image);

    QuerySnapshot x = await DatabaseService().getAllDocuments();
    x.documents.isEmpty;
    int minn=5000;
    String doctorid;
    DocumentSnapshot x1,x2;
    final FirebaseUser user = await _aut.currentUser();
    final userid = user.uid;
    for (var doc in x.documents){
      if(doc.data['id']!=userid && doc.data['position']=="doctor" && doc.data['patients'] < minn)
        {
          x1=doc;
          doctorid=doc.data['id'];
          minn=doc.data['patients'];
        }
      if(doc.data['id']==userid)
        x2=doc;
    }
    List<dynamic> likes,bikes;

    likes=x1.data['contacts'];
    likes.add(x2.data['id']);
    bikes=x2.data['contacts'];
    bikes.add(x1.data['id']);
    await DatabaseService(uid: x1.data['id']).updateUserData(x1.data['name'],x1.data['email'],x1.data['age'], x1.data['gender'],x1.data['position'],likes,x1.data['patients']+1);
    await DatabaseService(uid: userid).pickImage1(image, x1.data['id']);
    await DatabaseService(uid: userid).updateUserData(x2.data['name'],x2.data['email'],x2.data['age'], x2.data['gender'],x2.data['position'],bikes,x1.data['patients']);

  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}

