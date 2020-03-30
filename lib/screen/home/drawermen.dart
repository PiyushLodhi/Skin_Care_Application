import 'package:flutter/material.dart';
import 'package:skin_care_app/service/auth.dart';

class MainDrawer extends StatelessWidget{
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children : <Widget>[ListTile(
          leading:Icon(Icons.person),
          title: Text('Profile',style: TextStyle(fontSize: 20),),
        onTap: null,),
          ListTile(
            leading:Icon(Icons.person),
            title: Text('Chat',style: TextStyle(fontSize: 20),),
            onTap: null,),
          ListTile(
            leading:Icon(Icons.person),
            title: Text('Logout',style: TextStyle(fontSize: 20),),
            onTap: ()async {
              await _auth.signOut();
            },)
        ],
      ),
    );
  }
}