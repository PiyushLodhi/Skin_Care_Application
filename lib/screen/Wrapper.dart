import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/authenticate/authenticate.dart';
import 'package:skin_care_app/screen/home/home.dart';


class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user ==null) {
      return Authenticate();
    }
    else
      return Home();
  }
}