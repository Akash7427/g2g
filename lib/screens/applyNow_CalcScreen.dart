import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/applyNow_WebView.dart';
import 'package:g2g/screens/comparision_Rate_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var total;
  var weekly;
  var final_output;
  var interest_rate = 0.00907;
  var payment_montly;
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;

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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('images/bg.jpg'),
                    fit: BoxFit.cover),
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
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 10.0, right: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/logo2.png',
                                            height: _isLarge ? 400 : 120,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: Text(
                                                  'How much would you like to borrow?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 19.5),
                                                ),
                                              ),
                                              SliderTheme(
                                                data: SliderTheme.of(context).copyWith(
                                                  trackHeight: 4.0,

                                                ),
                                                child: Slider(
                                                  activeColor: Color(0xFF64A000),
                                                  inactiveColor:
                                                      Color(0xFF64A000),
                                                  mouseCursor: MouseCursor.defer,
                                                  value: selected_amount,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      selected_amount = v;

                                                      WeeklyRepayments();
                                                    });
                                                  },
                                                  label:
                                                      '\$ ${selected_amount.toInt()}',
                                                  min: 500,
                                                  max: 5000,
                                                  divisions: 100,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '\$ ${selected_amount.toInt()}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                    Text(
                                                      '\$ 5000',
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: Text(
                                                      'For how long?',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 19.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SliderTheme(
                                                data: SliderTheme.of(context).copyWith(
                                                  trackHeight: 4.0,
                                                ),
                                                child: Slider(
                                                  activeColor: Color(0xFF64A000),
                                                  inactiveColor:
                                                      Color(0xFF64A000),

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
                                                      if (selected_amount >=
                                                          2001) {
                                                        setState(() {
                                                          selected_duration_end =
                                                              104;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selected_duration_end =
                                                              52;
                                                        });
                                                      }
                                                      WeeklyRepayments();
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${selected_duration.toInt()} Weeks',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      '${selected_duration_end.toInt()} Weeks',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(

                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Weekly Repayments',
                                                        textAlign: TextAlign.start,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                color:
                                                                    Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(width:10),
                                                    Expanded(
                                                      child: Text(
                                                        'Total Repayments',
                                                        textAlign: TextAlign.end,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                color:
                                                                    Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,

                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(vertical:15),
                                                        color: Color(0xFFC2E8F7),
                                                        child: Text(
                                                          '\$ ${(amountinTwo(weekly)) == '0.0' ? '155.0' : (amountinTwo(weekly))}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width:100),
                                                    
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.symmetric(vertical:15),
                                                        color: Color(0xFFC2E8F7),
                                                        child: Text(

                                                          '\$ ${(amountinTwo(total)) == '0.0' ? '620.0' : (amountinTwo(total))}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: InkWell(
                                            child: Text(
                                              'Comparison Rate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: Color(0xFF27A1E1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ApplyLoansWebViewScreen(
                                              amount: selected_amount
                                                  .toInt()
                                                  .toString(),
                                              term: selected_duration
                                                      .toInt()
                                                      .toString() ??
                                                  '4',
                                            ),
                                          ),
                                        );
                                      },
                                      color: Color(0xFF17477A),
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 30,
                                          right: 30),
                                      child: Container(
                                        child: Text(
                                          'Next'.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
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
                                          horizontal: 10,vertical:10),
                                      color: Color(0xFFF2F2F2),
                                      child: Text(
                                        'NOTE: The figures represented in this calculator are an example only and may not represent actual repayments contractual or otherwise.',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // RaisedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ApplyLoansWebViewScreen(
                        //           amount: selected_amount.toInt().toString(),
                        //           term:
                        //               selected_duration.toInt().toString() ??
                        //                   '4',
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   color: Color(0xFF27A1E1),
                        //   padding: EdgeInsets.only(
                        //       top: 15, bottom: 15, left: 30, right: 30),
                        //   child: Container(
                        //     child: Text(
                        //       'Next',
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 25,
                        //         letterSpacing: 1.0,
                        //         fontWeight: FontWeight.w900,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  String amountinTwo(content) {
    int decimals = 2;
    int fac = pow(10, decimals);
    double d = content ?? 0;
    d = (d * fac).round() / fac;
    print("d: $d");

    return d.toString();
  }
}
