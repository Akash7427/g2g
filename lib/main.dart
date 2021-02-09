import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/controllers/transactionsController.dart';
import 'package:g2g/screens/splashScreen.dart';
import 'package:provider/provider.dart';

import 'controllers/accountsController.dart';
import 'controllers/file_doc_controller.dart';
import 'controllers/loanDocController.dart';

void main() =>runApp(

    Good2GoApp());


class Good2GoApp extends StatefulWidget {
  @override
  _Good2GoAppState createState() => _Good2GoAppState();
}

class _Good2GoAppState extends State<Good2GoApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx)=>  LoanDocController()),
            ChangeNotifierProvider(create: (ctx)=>  FileDocController()),
            ChangeNotifierProvider(create:(ctx)=> ClientController()),
            ChangeNotifierProvider(create:(ctx)=> AccountsController()),
            ChangeNotifierProvider(create:(ctx)=> TransactionsController())

          ],
          child: MaterialApp(
        theme: ThemeData(
         primaryColor: kPrimaryColor,
         accentColor: kSecondaryColor,
          brightness: Brightness.light,


          // Define the default font family.
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0,fontFamily: 'Montserrat-Regular'),
            headline2:  TextStyle(fontSize: 48.0,fontFamily: 'Montserrat-Regular'),
              headline3:  TextStyle(fontSize: 35.0,fontFamily: 'Montserrat-Regular'),
              headline4:  TextStyle(fontSize: 32.0,fontFamily: 'Montserrat-Regular'),
              headline5:  TextStyle(fontSize: 24.0,fontFamily: 'Montserrat-Regular'),
            headline6: TextStyle(fontSize: 20.0,fontFamily: 'Montserrat-Regular'),
            bodyText2: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat-Regular'),
            bodyText1: TextStyle(fontSize: 24.0, fontFamily: 'Montserrat-Regular')
          ),
        ),
        debugShowCheckedModeBanner: false,
        home:SplashScreen(seconds: 3,loaderColor: kPrimaryColor,image: Image.asset('images/logo.png'),photoSize: 220,)
      ),
    );
  }
}