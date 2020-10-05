import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/editProfile.dart';
import 'package:g2g/screens/loanDocumentsScreen.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/screens/twakToScreen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:g2g/screens/updatePasswordScreen.dart';


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
    var clientProvider = Provider.of<ClientController>(context,listen: false);
    var accountProvider =Provider.of<AccountsController>(context,listen: false);
    
    
    return Drawer(
      child: FutureBuilder(
        future:clientProvider.fetchClientNameofSharedP(),
              builder:(context,snapshot)=> Container(
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
                        if(snapshot.connectionState== ConnectionState.waiting)
                          CircularProgressIndicator(),
                        
                        
                        Text(
                         clientProvider.getClientName ,
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
                              logout();
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
                                
                                Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoanDocuments(accountProvider.getAccountsList()[0])));
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
                                Navigator.pop(
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
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: _isLarge ? 22 : 18,
                                    color: kWhiteColor),
                              ),
                              onTap: () {
                                // Update the state of the app.
                                // ...
                              },
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 30),
                          height: 100,
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Apply Now',

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
                                  fontSize: _isLarge ? 24 : 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),

                            color: kPrimaryColor,

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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final secureStorage = new FlutterSecureStorage();
    await preferences.clear();
    await secureStorage.deleteAll();
   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));


  }
}
