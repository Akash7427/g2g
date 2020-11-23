import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  final _connectScreenKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
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
            child: Column(children: <Widget>[
              Expanded(
                child: Container(
                  child: InAppWebView(
                    initialUrl: "https://tawk.to/chat/580d5a22d0f23f0cd8dc1448/default",
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller,
                        String url) async{
                      String result2 = await controller.evaluateJavascript(
                          source: """
                       <script type="text/javascript">
var Tawk_API=Tawk_API||{};
Tawk_API.visitor = {
name : 'visitor name',
email : 'visitor@email.com'
};

var Tawk_LoadStart=new Date();
<!-- rest of the tawk.to widget code 
</script>
                      """);
                      print(result2);

                    },
                    onLoadStop: (InAppWebViewController controller,
                        String url) async {

                     // Foo Bar

                    },
                  ),
                ),
              ),
            ]))
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
    //   SpinKitPouringHourglass(color: kPrimaryColor, size: _width * 0.25),
    //   hidden: true,
    // );

  }
}