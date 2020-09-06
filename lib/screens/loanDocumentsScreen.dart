import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
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
                child: Icon(
                  Icons.call,
                  size: _isLarge ? 35 : 30,
                ),
              )),
          InkWell(
              onTap: () {
                Alert(
                    context: context,
                    title: 'Are you sure you want to Logout?',
                    style: AlertStyle(isCloseButton: false,titleStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                              fontSize: _isLarge ? 26 : 20)),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _isLarge ? 24 : 18),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: kSecondaryColor,
                        radius: BorderRadius.circular(10.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _isLarge ? 24 : 18),
                        ),
                        onPressed: (){
                           SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('isLoggedIn');
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()),
                      (r) => false);
                });
                        },
                        color: Colors.grey[600],
                        radius: BorderRadius.circular(10.0),
                      ),
                    ]).show();
               
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.exit_to_app,
                  size: _isLarge ? 35 : 30,
                ),
              )),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
        title: Text('Loan Documents',
            style: TextStyle(
                fontSize: _isLarge ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _documentScaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        buildHeader(),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < 3; i++)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: buildDocumentCard(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
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
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      )),
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        Card(
            color: widget.account.status.toUpperCase() == 'OPEN'
                ? kPrimaryColor
                : (widget.account.status.toUpperCase() == 'QUOTE'
                    ? Colors.amber[300]
                    : Colors.red),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Text(widget.account.status.toUpperCase(),
                  style: TextStyle(
                      fontSize: _isLarge ? 25 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.account.accountTypeDescription,
                style: TextStyle(
                    fontSize: _isLarge ? 25 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            Text(
              widget.account.accountID,
              style: TextStyle(
                  fontSize: _isLarge ? 25 : 15,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDocumentCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: ListTile(
          dense: true,
          trailing: Column(
            children: [
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Text(
                  'Download',
                  style: TextStyle(
                      fontSize: _isLarge ? 22 : 16,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan Contract',
                  style: TextStyle(
                    fontSize: _isLarge ? 22 : 16,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 5),
              Text('26/07/2020',
                  style: TextStyle(
                    fontSize: _isLarge ? 22 : 16,
                  )),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
