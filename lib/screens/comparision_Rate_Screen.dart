import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../responsive_ui.dart';

// ignore: camel_case_types
class Comparision_Rate_WebView extends StatefulWidget {
  @override
  Comparision_Rate_WebViewState createState() =>
      Comparision_Rate_WebViewState();
}

// ignore: camel_case_types
class Comparision_Rate_WebViewState extends State<Comparision_Rate_WebView> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  String hight;
  double webHight = 400; //default some value
  Future funcThatMakesAsyncCall() async {
    var result =
    await _controller.evaluateJavascript('document.body.scrollHeight');
    //here we call javascript for get browser data
    setState(
          () {
        hight = result;
      },
    );
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
        top: MediaQuery.of(context).size.height * 0.1,
        left: 0.0,
        bottom: 0.0,
        right: 0.0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: WebView(
              initialUrl: 'https://www.goodtogoloans.com.au/cash-loans/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController c) async {
                setState(() {
                  _controller = c;
                });
                var a, b;

                await _controller.getScrollX().then((value) {
                  setState(() {
                    a = value;
                    print('x' + value.toString());
                  });
                });
                await _controller.getScrollY().then((value) {
                  setState(() {
                    b = value;
                    print('Y' + value.toString());
                  });
                });
                await _controller.scrollBy(1000, 3600);
              },
              onPageStarted: (String url) {
                if (url.startsWith('tel:')) launch("tel://1300197727");
              },
              onPageFinished: (String url) async{
                await _controller.evaluateJavascript('window.scrollTo({top: 2500, behavior: "smooth"});');
              },
            ),
          ),
        ),
      ),
    ]);
  }
}