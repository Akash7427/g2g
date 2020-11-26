import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/tawk/tawk_visitor.dart';
import 'package:g2g/tawk/tawk_widget.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/controllers/clientController.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:g2g/models/tawk_visitor.dart';
import 'dart:convert';


class TawkToScreen extends StatefulWidget {
  @override
  _TawkToScreenState createState() => _TawkToScreenState();
}

class _TawkToScreenState extends State<TawkToScreen> {
  final _connectScreenKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  String name;
  String email;
  String clientID;

  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    await ClientController().getClientBasic();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(PrefHelper.PREF_FULLNAME) ?? '';
      email = prefs.getString(PrefHelper.PREF_EMAIL_ID) ?? '';
      clientID = prefs.getString(PrefHelper.Pref_CLIENT_ID) ?? '';
      print(name);
      print(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return Scaffold(
      key: _connectScreenKey,
      drawer: NavigationDrawer(),
      body: Stack(children: [
        new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
          child: AppBar(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xffccebf2),
              child: IconButton(
                onPressed: () {
                  print('abc');
                  _connectScreenKey.currentState.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: kSecondaryColor,
                  size: _isLarge ? 35 : 30,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(),
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
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        Positioned(
          top: 110.0,
          left: 0.0,
          bottom: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Tawk(
              directChatLink:
              'https://tawk.to/chat/580d5a22d0f23f0cd8dc1448/default',
              visitor:
              TawkVisitor(name: name, email: email, ClientID: clientID),
            ),
          ),
        ),
      ]),
    );

    // return WebviewScaffold(
    //   key: _connectScreenKey,
    //   appBar: AppBar(
    //     actions: [
    //       InkWell(
    //           onTap: () {
    //             launch("tel://1300197727");
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //             child: Icon(
    //               Icons.call,
    //               size: _isLarge ? 35 : 30,
    //             ),
    //           )),
    //       InkWell(
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //             child: Icon(
    //               Icons.home,
    //               size: _isLarge ? 35 : 30,
    //             ),
    //           )),
    //     ],
    //     backgroundColor: Colors.white,
    //     iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
    //     title: Text('Connect',
    //         style: TextStyle(
    //             fontSize: _isLarge ? 28 : 22,
    //             fontWeight: FontWeight.bold,
    //             color: kSecondaryColor)),
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back, color: kSecondaryColor, size: 30),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ),
    //   resizeToAvoidBottomInset: true,
    //   withJavascript: true,
    //   url: 'https://tawk.to/chat/5f3278b420942006f46a9dc2/default',
    //   initialChild:
    //       SpinKitPouringHourglass(color: kPrimaryColor, size: _width * 0.25),
    //   hidden: true,
    // );
    // Scaffold(
    //   key: _connectScreenKey,
    //   drawer: NavigationDrawer(),
    //   appBar:

    //   body:
    //   SafeArea(
    //           child:  WebView(
    //      initialUrl: 'https://tawk.to/chat/5f3278b420942006f46a9dc2/default',
    //      javascriptMode: JavascriptMode.unrestricted,

    //      onWebViewCreated: (WebViewController webViewController) async {
    //             _controller=webViewController;
    //          webViewController.loadUrl('https://tawk.to/chat/5f3278b420942006f46a9dc2/default');

    //         },
    //     ),
    //   )
    // );
  }
}
// <!--Start of Tawk.to Script-->
// <script type="text/javascript">
// "var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
// (function(){
// var s1=document.createElement(\"script\"),s0=document.getElementsByTagName(\"script\")[0];
// s1.async=true;
// s1.src='https://embed.tawk.to/5f3278b420942006f46a9dc2/default';
// s1.charset=\'UTF-8\';
// s1.setAttribute(\'crossorigin\',\'*\');
// s0.parentNode.insertBefore(s1,s0);
// })();"
// </script>
// <!--End of Tawk.to Script-->
