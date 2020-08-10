import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_care_app/models/brew.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/service/database.dart';
import 'package:skin_care_app/shared/constants.dart';
import 'package:skin_care_app/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  @override

  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['Male', 'Female', 'Other'];
  // form values
  String _currentName;
  String _currentSugars;
  String _currentAge;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final dat=Provider.of<QuerySnapshot>(context);
    print(user.uid);
   return  StreamBuilder<Brew>(
      stream: DatabaseService(uid: user.uid).userData1,
      builder: (context, snapshot) {
        print(snapshot.data);
        if(dat.documents.isNotEmpty)//.hasData)
          {print("Helo");
          DocumentSnapshot userdata;
            final userd=dat.documents;
            for(var doc in userd)
              {
                if(doc.data['id']==user.uid)
                  userdata=doc;
              }
            print(userdata.data['id']);
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your Profile.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration,
                    initialValue: userdata.data['name']=='user'?'Enter Name':userdata.data['name'],
                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText:'Age' ,
                      labelStyle: TextStyle(fontSize: 20),
                      contentPadding: EdgeInsets.all(12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 2.0),
                      )
                    ),
                    initialValue: userdata.data['age'].toString(),
                    validator: (val) => val.isEmpty ? 'Please enter age' : null,
                    onChanged: (val) => setState(() => _currentAge = val),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: _currentSugars ?? userdata.data['gender'],
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      //print(sugar);
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val ),
                  ),
                  //print("dfg");
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        print(_currentName);
                        print(_currentSugars);
                        print(_currentAge);
                        if(_formKey.currentState.validate())
                          {
                            await DatabaseService(uid: user.uid).updateUserData(_currentName ?? userdata.data['name'],userdata.data['email'],int.parse(_currentAge ?? userdata.data['age']), _currentSugars ?? userdata.data['gender'],userdata.data['position'],userdata.data['contacts'],userdata.data['patients']);

                          }
                      }
                  ),
                ],
              ),
            );
          }
        else
          {
              return Loading();
          }

      }
    );
  }
}