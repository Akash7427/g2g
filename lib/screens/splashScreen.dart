import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/homeScreen.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    Timer(Duration(seconds: widget.seconds), () async {
      Client user;
      List<Account> accounts;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      print(prefs.getBool('isLoggedIn'));
      if (prefs.getString(PrefHelper.PREF_AUTH_TOKEN) == null) {
        await ClientController().authenticateUser();
        print(prefs.getString(PrefHelper.PREF_AUTH_TOKEN));
      }
      if (prefs.getBool('isLoggedIn') ?? false) {
        user = await ClientController().authenticateClient(
            prefs.getString('clientID'), prefs.getString('password'));
        accounts = await AccountsController()
            .getAccounts(prefs.getString('clientID'), user.sessionToken);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(user, accounts)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    _width = MediaQuery
        .of(context)
        .size
        .width;
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
}
