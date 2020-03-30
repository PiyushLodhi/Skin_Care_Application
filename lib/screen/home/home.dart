
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skin_care_app/lastsort/all_users_screen.dart';
import 'package:skin_care_app/lastsort/main.dart';
import 'package:skin_care_app/models/brew.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/home/brewlist.dart';
import 'package:skin_care_app/screen/home/drawermen.dart';
import 'package:skin_care_app/service/auth.dart';
import 'package:skin_care_app/service/database.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
class Home extends StatefulWidget {
  @override
  _MyAppState1 createState() => _MyAppState1();
}

class _MyAppState1 extends State<Home> {
  final AuthService _auth = AuthService();
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
    return Scaffold(
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
      drawer: MainDrawer(),
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
                  MaterialPageRoute(builder: (context) => AllUsersScreen()),
                );
              },
              child: Text('Doctor Consultant'),
              color: Colors.lightBlue,
            ),
          ]
      ),
    ]),
    );
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
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

