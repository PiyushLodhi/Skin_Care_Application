import 'package:flutter/material.dart';
import 'package:skin_care_app/screen/authenticate/register.dart';
import 'package:skin_care_app/screen/authenticate/sign_in.dart';
class Authenticate extends StatefulWidget
{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}
class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView:  toggleView);
    } else {
      return Register(toggleView:  toggleView);
    }
  }
}
