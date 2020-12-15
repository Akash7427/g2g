import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../responsive_ui.dart';

class ApplyLoansWebViewScreen extends StatefulWidget {
  final String amount;
  final String term;

  ApplyLoansWebViewScreen({this.amount, this.term});

  @override
  ApplyLoansWebViewScreenState createState() => ApplyLoansWebViewScreenState();
}

class ApplyLoansWebViewScreenState extends State<ApplyLoansWebViewScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return Stack(children: [
      new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('images/bg.jpg'), fit: BoxFit.cover),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
        child: AppBar(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xffccebf2),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: kSecondaryColor,
                size: _isLarge ? 35 : 30,
              ),
            ),
          ),
          actions: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xffccebf2),
              child: IconButton(
                onPressed: () {
                  launch("tel://1300197727");
                },
                icon: Icon(
                  Icons.call,
                  color: kSecondaryColor,
                  size: _isLarge ? 35 : 30,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 1.5,
        left: 0.0,
        bottom: 0.0,
        right: 0.0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: WebView(
              initialUrl:
                  'https://www.goodtogoloans.com.au/application-form/?amount=${widget.amount}&term=${widget.term}',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController c) {},
              onPageStarted: (String url) {
                if (url.startsWith('tel:')) launch("tel://1300197727");
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
