import 'package:flutter/material.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/editProfile.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/screens/transactionScreen.dart';
import 'package:g2g/screens/twakToScreen.dart';
import 'package:g2g/screens/updatePasswordScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  Client client;
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
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('images/logo2.png'),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mark Thomas',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Alert(
                              context: context,
                              title: 'Are you sure you want to Logout?',
                              style: AlertStyle(
                                  isCloseButton: false,
                                  titleStyle: TextStyle(
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
                                  radius: BorderRadius.circular(10),
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _isLarge ? 24 : 18),
                                  ),
                                  onPressed: () {
                                    SharedPreferences.getInstance()
                                        .then((prefs) {
                                      prefs.remove('isLoggedIn');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginScreen()),
                                          (r) => false);
                                    });
                                  },
                                  color: Colors.grey[600],
                                ),
                              ]).show();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Logout ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondaryColor),
                            ),
                            Icon(Icons.arrow_forward, color: kSecondaryColor)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [kSecondaryColor, kPrimaryColor],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                )),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: Icon(Icons.settings,
                                size: _isLarge ? 28 : 24, color: kWhiteColor),
                            title: Text(
                              'Edit Profile',
                              style: TextStyle(
                                  fontSize: _isLarge ? 22 : 18,
                                  color: kWhiteColor),
                            ),
                            onTap: () async {
                              final pr = ProgressDialog(context);
                              pr.show();
                              ClientController()
                                  .getClientBasic()
                                  .then((clientData) {
                                pr.hide();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfile(clientData)),
                                    (r) => r.isFirst);
                              });
                            },
                          ),
                          ListTile(
                            leading: ImageIcon(
                                AssetImage('images/documents.png'),
                                size: _isLarge ? 28 : 24,
                                color: kWhiteColor),
                            title: Text(
                              'Documents',
                              style: TextStyle(
                                  fontSize: _isLarge ? 22 : 18,
                                  color: kWhiteColor),
                            ),
                            onTap: () {
                              // Update the state of the app.

                              // ...
                            },
                          ),
                          ListTile(
                            leading: ImageIcon(AssetImage('images/loan.png'),
                                size: _isLarge ? 28 : 24, color: kWhiteColor),
                            title: Text(
                              'My Loans',
                              style: TextStyle(
                                  fontSize: _isLarge ? 22 : 18,
                                  color: kWhiteColor),
                            ),
                            onTap: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                              // Update the state of the app.
                              // ...
                            },
                          ),
                          ListTile(
                            leading: ImageIcon(AssetImage('images/connect.png'),
                                size: _isLarge ? 28 : 24, color: kWhiteColor),
                            title: Text(
                              'Connect',
                              style: TextStyle(
                                  fontSize: _isLarge ? 22 : 18,
                                  color: kWhiteColor),
                            ),
                            onTap: () async {
                              // launch('https://tawk.to/chat/5f3278b420942006f46a9dc2/default',forceSafariVC: true,forceWebView: true);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TawkToScreen()),
                                  (r) => r.isFirst);
                              // Update the state of the app.
                              // ...
                            },
                          ),
                          // ListTile(
                          //   leading: Icon(Icons.pin_drop),
                          //   title: Text('Reset PIN',style: TextStyle(fontSize:18),),
                          //   onTap: () {
                          //     // Update the state of the app.
                          //     // ...
                          //   },
                          // ),
                          ListTile(
                            leading: ImageIcon(AssetImage('images/lock.png'),
                                size: _isLarge ? 28 : 24, color: kWhiteColor),
                            title: Text(
                              'Update Password',
                              style: TextStyle(
                                  fontSize: _isLarge ? 22 : 18,
                                  color: kWhiteColor),
                            ),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdatePassword()));
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 10, bottom: 30),
                        height: 100,
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            'Apply Now',
                            style: TextStyle(
                                fontSize: _isLarge ? 24 : 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
