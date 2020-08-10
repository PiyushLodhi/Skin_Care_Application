  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_care_app/models/user.dart';
import 'package:skin_care_app/screen/Wrapper.dart';
import 'package:skin_care_app/service/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:skin_care_app/screen/Wrapper.dart';

void main() => runApp(EasyLocalization(
    supportedLocales: [Locale('en', 'US'), Locale('hindi', '')],
    path: 'assets/languages', // <-- change patch to your
    fallbackLocale: Locale('en', 'US'),
    child: MyApp()
),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //var lang=EasyLocalizationProvider.of(context).data;
    return StreamProvider<User>.value(
      value : AuthService().user,
      child : MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner:false ,
        home: Wrapper(),
      )
      );
    }
  }


