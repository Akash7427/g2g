import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/applyNow_WebView.dart';
import 'package:g2g/screens/comparision_Rate_Screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class ApplyNowForLoan extends StatefulWidget {
  @override
  _ApplyNowForLoanState createState() => _ApplyNowForLoanState();
}

class _ApplyNowForLoanState extends State<ApplyNowForLoan> {
  double selected_amount = 500.0;
  double selected_duration = 4.0;
  double selected_duration_end = 52.0;
  var term;

//(selected_duration/4).ceil()
  var interest_per_annum = 47 / 100;
  var loan_fees = 400;
  var frequency = 365; // frequency for reducible interest calculated i.e. daily
  var payment_frequency = 104;
  double total;
  double weekly;
  var final_output;
  var interest_rate = 0.00907;
  var payment_montly;
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;

  double minSliderAmount = 500;
  double maxSliderAmount = 5000;
  double sliderDivision = 0;
  void _showDialog(amount, term) {
    Alert(
            context: context,
            onWillPopActive: true,
            closeIcon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            closeFunction: () {
              Navigator.pop(context);
            },
            title: '',
            buttons: [
              DialogButton(
                color: Colors.green,
                child: AutoSizeText(
                  "Apply Now",
                  style: TextStyle(
                      color: Colors.white, fontSize: _isLarge ? 24 : 18),
                ),
                onPressed: () async {
                  //https://www.goodtogoloans.com.au/application-form/?amount=${widget.amount}&term=${widget.term}
                  try {
                    String url =
                        'https://www.goodtogoloans.com.au/application-form/?amount=${amount}&term=${term}'
                            .replaceAll(' ', '%20');
                    print(url);
                    await _launchInWebViewWithJavaScript(url);
                  } on Exception catch (e) {
                    print(e.toString());
                  }
                },
              )
            ],
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: _width * 0.7,
                height: _height * 0.6,
                child: WebView(
                  gestureNavigationEnabled: true,
                  initialUrl:
                      'https://www.goodtogoloans.com.au/warning-app.php',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController c) {},
                  onPageStarted: (String url) {
                    if (url.startsWith('tel:')) launch("tel://1300197727");
                  },
                ),
              ),
            ),
            style: AlertStyle(
                isCloseButton: true,
                isOverlayTapDismiss: true,
                titleStyle: TextStyle(fontSize: 1)))
        .show();
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    double maxValue = selected_duration_end > 0 ? selected_duration_end : 0;
    double progress = selected_duration_end > selected_duration
        ? selected_duration
        : selected_duration_end;

    sliderDivision = (maxSliderAmount - minSliderAmount) / 100;

    WeeklyRepayments();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
            child: SafeArea(child: GestureDetector(
              onPanDown: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            )),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
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

                _isLarge?SizedBox(height: _height*0.15 ,):Container(),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Image.asset(
                                  _isLarge
                                      ? 'images/fulllogo.png'
                                      : 'images/logobig.png',
                                  height: _isLarge ? 200 : 150,
                                  width: _isLarge ? 500 : 150,
                                  fit: BoxFit.fitWidth,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 10.0, right: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: AutoSizeText(
                                              'How much would you like to borrow?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 19.5),
                                            ),
                                          ),
                                          SliderTheme(
                                            data: SliderThemeData(
                                                trackHeight: 4.0,
                                                valueIndicatorColor: Colors.blue,
                                                showValueIndicator:
                                                    ShowValueIndicator.always),
                                            child: Slider(
                                              activeColor: Color(0xFF64A000),
                                              inactiveColor: Color(0xFF64A000),
                                              value: selected_amount,
                                              onChanged: (v) {
                                                setState(() {
                                                  selected_amount = v;

                                                  WeeklyRepayments();
                                                });
                                              },
                                              label:
                                                  '\$ ${selected_amount.toStringAsFixed(0)}',
                                              min: minSliderAmount,
                                              max: maxSliderAmount,
                                              divisions: sliderDivision.toInt(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  '\$ ${minSliderAmount.toInt()}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                                AutoSizeText(
                                                  '\$ ${maxSliderAmount.toInt()}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 22,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: AutoSizeText(
                                                  'For how long?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 19.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                                trackHeight: 4.0,
                                                valueIndicatorColor: Colors.blue,
                                                showValueIndicator:
                                                    ShowValueIndicator.always),
                                            child: Slider(
                                              activeColor: Color(0xFF64A000),
                                              inactiveColor: Color(0xFF64A000),
                                              mouseCursor: MouseCursor.defer,
                                              value: progress,
                                              onChanged: (v) {
                                                setState(() {
                                                  WeeklyRepayments();
                                                });
                                                setState(() {
                                                  selected_duration = v;
                                                });
                                              },
                                              label:
                                                  '${selected_duration.toInt()} Weeks',
                                              min: 4,
                                              max: maxValue,
                                              divisions: 48,
                                              onChangeStart: (value) {
                                                setState(() {
                                                  if (selected_amount >= 2001) {
                                                    setState(() {
                                                      selected_duration_end = 104;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selected_duration_end = 52;
                                                    });
                                                  }
                                                  WeeklyRepayments();
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  '4 Weeks',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                AutoSizeText(
                                                  '${selected_duration_end.toInt()} Weeks',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    'Weekly Repayments',
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    'Total Repayments',
                                                    textAlign: TextAlign.end,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 15),
                                                    color: Color(0xFFC2E8F7),
                                                    child: AutoSizeText(
                                                      '\$ ${weekly?.toStringAsFixed(2) == '0.0' ? '155.0' : weekly?.toStringAsFixed(2)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight.w900),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: _isLarge?60:20),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 15),
                                                    color: Color(0xFFC2E8F7),
                                                    child: AutoSizeText(
                                                      '\$ ${total?.toStringAsFixed(2) == '0.0' ? '620.0' : total?.toStringAsFixed(2)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight.w900),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 25),
                                          child: InkWell(
                                            child: AutoSizeText(
                                              'Comparison Rate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: Color(0xFF27A1E1),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Comparision_Rate_WebView()));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        _showDialog(
                                            selected_amount.toInt().toString(),
                                            selected_duration.toInt().toString() ??
                                                '4');
                                        //https://www.goodtogoloans.com.au/warning-app.php

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         ApplyLoansWebViewScreen(
                                        //           amount: selected_amount
                                        //               .toInt()
                                        //               .toString(),
                                        //           term: selected_duration
                                        //               .toInt()
                                        //               .toString() ??
                                        //               '4',
                                        //         ),
                                        //   ),
                                        // );
                                      },
                                      color: Color(0xFF17477A),
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 20, right: 20),
                                      child: Container(
                                        child: AutoSizeText(
                                          'Next'.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      color: Color(0xFFF2F2F2),
                                      child: AutoSizeText(
                                        'NOTE: The figures represented in this calculator are an example only and may not represent actual repayments contractual or otherwise.',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String WeeklyRepayments() {
    term = ((selected_duration) / 4).ceil();
    var new1 = (0.2 * selected_amount);
    var new2 = ((0.04 * selected_amount) * term);
    print(term.toString());
    setState(() {
      if (selected_amount <= 2000) {
        setState(() {
          total = selected_amount + new1 + new2;
          print('total' + total.toString());
          weekly = total / selected_duration;
          print('weekly' + weekly.toString());
        });
      }
      if (selected_amount >= 2001) {
        setState(() {
          interest_rate = 0.00907;
          payment_montly = ((selected_amount + loan_fees) *
                  interest_rate *
                  (pow((1 + interest_rate), selected_duration))) /
              ((pow((1 + interest_rate), selected_duration)) - 1);
          total = payment_montly * selected_duration;
          weekly = payment_montly;
        });
      }
      print('Weekly :' + weekly.toString());
    });
  }

// String amountinTwo(content) {
//   int decimals = 2;
//   int fac = pow(10, decimals);
//   double d = content ?? 0;
//   d = (d * fac).round() / fac;
//   print("d: $d");
//
//   return d.toString();
// }
}
