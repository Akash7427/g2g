import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/homeScreen.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:g2g/constants.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final dynamic navigateAfterSeconds;
  final double photoSize;
  final dynamic onClick;
  final Color loaderColor;
  final Image image;
  final Text loadingText;
  final ImageProvider imageBackground;
  final Gradient gradientBackground;

  SplashScreen(
      {this.loaderColor,
      @required this.seconds,
      this.photoSize,
      this.onClick,
      this.navigateAfterSeconds,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      this.image,
      this.loadingText = const Text(""),
      this.imageBackground,
      this.gradientBackground});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    tryAuthenticate();
   

  }

  void tryAuthenticate(){
    Timer(
        Duration(seconds: widget.seconds),
            () async{
          Client user;
          List<Account> accounts;
          SharedPreferences prefs=await SharedPreferences.getInstance();
          final secureStorage= new FlutterSecureStorage();
          print(prefs.getBool('isLoggedIn'));
          if(prefs.getBool('isLoggedIn')??false)
          {
            await Provider.of<ClientController>(context,listen: false).authenticateUser();
            String ePass = await secureStorage.read(key: PrefHelper.PREF_PASSWORD);
            user=await Provider.of<ClientController>(context,listen: false).authenticateClient(prefs.getString(PrefHelper.PREF_USER_ID),ePass,true);
            if(user==null)
              showAlert();
            accounts=await Provider.of<AccountsController>(context,listen: false).getAccounts(prefs.getString(PrefHelper.Pref_CLIENT_ID), user.sessionToken);

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(),settings: RouteSettings(
              arguments: 1,
            )));
          }
          else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.jpg'),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black12, BlendMode.overlay))),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('images/logo.png', width: _width),
              SpinKitThreeBounce(
                color: Colors.white,
                size: _width * 0.14,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showAlert(){
    return new Alert(
        context: context,
        title:
        'Invalid Credentials',
        type: AlertType.error,


        buttons: [
          DialogButton(
            child: Text(
              "Login",
              style: TextStyle(
                  color:
                  Colors.white,
                  fontSize: _isLarge
                      ? 24
                      : 18),
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen())),
            color: kPrimaryColor,
            radius: BorderRadius
                .circular(0.0),
          ),
          DialogButton(
            child: Text(
              "Retry",
              style: TextStyle(
                  color:
                  Colors.white,
                  fontSize: _isLarge
                      ? 24
                      : 18),
            ),
            onPressed: () {
              Navigator.pop(context);
              tryAuthenticate();

    }
                ,
            color: kPrimaryColor,
            radius: BorderRadius
                .circular(0.0),
          )
        ],
        style: AlertStyle(
          animationType:
          AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss:
          false,
          titleStyle: TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: _isLarge
                  ? 24
                  : 18),
        )).show();
  }

}
