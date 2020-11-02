import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApplyNowScreen extends StatefulWidget {
  @override
  ApplyNowScreenState createState() => ApplyNowScreenState();
}

class ApplyNowScreenState extends State<ApplyNowScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://www.goodtogoloans.com.au/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController c){



        
      },
      onPageStarted: (String url){
        if(url.startsWith('tel:'))
          launch("tel://1300197727");

      },
    );
  }
}