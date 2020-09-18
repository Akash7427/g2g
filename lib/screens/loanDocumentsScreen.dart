import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/widgets/custom_loandoc_item.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoanDocuments extends StatefulWidget {
  final Account account;
  LoanDocuments(this.account);
  @override
  _LoanDocumentsState createState() => _LoanDocumentsState();
}

class _LoanDocumentsState extends State<LoanDocuments> {
  final _documentScaffoldKey = GlobalKey<ScaffoldState>();
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
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                launch("tel://1300197727");
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RawMaterialButton(
                    fillColor: Colors.blue[50],
                    child: Icon(Icons.call, color: kSecondaryColor, size: 30),
                    onPressed: () {
                      _documentScaffoldKey.currentState.openDrawer();
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
                  )
                  ),
          // InkWell(
          //     onTap: () {
          //       Alert(
          //           context: context,
          //           title: 'Are you sure you want to Logout?',
          //           style: AlertStyle(isCloseButton: false,titleStyle: TextStyle(
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold,
          //                     fontSize: _isLarge ? 26 : 20)),
          //           buttons: [
          //             DialogButton(
          //               child: Text(
          //                 "Close",
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: _isLarge ? 24 : 18),
          //               ),
          //               onPressed: () => Navigator.pop(context),
          //               color: kSecondaryColor,
          //               radius: BorderRadius.circular(10.0),
          //             ),
          //             DialogButton(
          //               child: Text(
          //                 "Logout",
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: _isLarge ? 24 : 18),
          //               ),
          //               onPressed: (){
          //                  SharedPreferences.getInstance().then((prefs) {
          //         prefs.remove('isLoggedIn');
          //         Navigator.of(context).pushAndRemoveUntil(
          //             new MaterialPageRoute(
          //                 builder: (BuildContext context) => LoginScreen()),
          //             (r) => false);
          //       });
          //               },
          //               color: Colors.grey[600],
          //               radius: BorderRadius.circular(10.0),
          //             ),
          //           ]).show();

          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Icon(
          //         Icons.exit_to_app,
          //         size: _isLarge ? 35 : 30,
          //       ),
          //     )),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
        leading: RawMaterialButton(
          fillColor: Colors.blue[50],
          child: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _documentScaffoldKey.currentState.openDrawer();
          },
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
      ),
      extendBodyBehindAppBar: true,
      key: _documentScaffoldKey,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      buildHeader(),
                      buildListHeader(),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0; i < 3; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: buildDocumentCard(widget.account),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FlatButton(
                          color: kSecondaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('BACK',
                                style: TextStyle(
                                    fontSize: _isLarge ? 25 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )),
                    ],
                  ),
                ]),
          ),
        ),
      )),
    );
  }

  Container buildListHeader() {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text('DATE',
                    style: TextStyle(
                        fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 4,
                child: Text('NAME',
                    style: TextStyle(
                        fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold)),
              ),
              Text('ACTIONS',
                  style: TextStyle(
                      fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold))
            ,
             ],
          ),
          Divider(
          color: Colors.black54,
        )
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.account.accountID,
                style: TextStyle(
                    fontSize: _isLarge ? 25 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
              Text(
                " - Loan Documents",
                style: TextStyle(
                    fontSize: _isLarge ? 25 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(widget.account.accountTypeDescription,
                    style: TextStyle(
                        fontSize: _isLarge ? 30 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(width: 10),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: widget.account.status.toUpperCase() == 'OPEN'
                      ? kPrimaryColor
                      : (widget.account.status.toUpperCase() == 'QUOTE'
                          ? Colors.amber[300]
                          : Colors.red),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                    child: Text(widget.account.status.toUpperCase(),
                        style: TextStyle(
                            fontSize: _isLarge ? 16 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDocumentCard(Account account) {
    return CustomLoandocItem(account, _isLarge);
  }
}
