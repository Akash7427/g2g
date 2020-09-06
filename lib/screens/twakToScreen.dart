import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TawkToScreen extends StatefulWidget {
  @override
  _TawkToScreenState createState() => _TawkToScreenState();
}

class _TawkToScreenState extends State<TawkToScreen> {
  final  _connectScreenKey=GlobalKey<ScaffoldState>();
  WebViewController _controller;
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return WebviewScaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                launch("tel://1300197727");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.call,
                  size: _isLarge ? 35 : 30,
                ),
              )),
              InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.home,
                  size: _isLarge ? 35 : 30,
                ),
              )),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
        title: Text('Connect',
            style: TextStyle(
                fontSize: _isLarge?28:22,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _connectScreenKey.currentState.openDrawer();
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      withJavascript: true,
      url: 'https://tawk.to/chat/5f3278b420942006f46a9dc2/default',initialChild: SpinKitPouringHourglass(color:kPrimaryColor,size:_width*0.25),hidden: true,);
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