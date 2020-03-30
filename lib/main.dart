  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/Wrapper.dart';
import 'package:skin_care_app/service/auth.dart';
//import 'package:skin_care_app/screen/Wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value : AuthService().user,
      child : MaterialApp(
        debugShowCheckedModeBanner:false ,
        home: Wrapper(),
      )
      );
    }
  }


