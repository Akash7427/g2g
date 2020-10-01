import 'package:flutter/material.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/screens/splashScreen.dart';
import 'package:provider/provider.dart';

import 'controllers/file_doc_controller.dart';
import 'controllers/loanDocController.dart';

void main() =>runApp(Good2GoApp());


class Good2GoApp extends StatefulWidget {
  @override
  _Good2GoAppState createState() => _Good2GoAppState();
}

class _Good2GoAppState extends State<Good2GoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx)=>  LoanDocController()),
            ChangeNotifierProvider(create: (ctx)=>  FileDocController()),

          ],
          child: MaterialApp(
        theme: ThemeData(
         primaryColor: kPrimaryColor,
         accentColor: kSecondaryColor,
        ),
        debugShowCheckedModeBanner: false,
        home:SplashScreen(seconds: 3,loaderColor: kPrimaryColor,image: Image.asset('images/logo.png'),photoSize: 220,)
      ),
    );
  }
}