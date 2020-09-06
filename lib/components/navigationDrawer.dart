import 'package:flutter/material.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/editProfile.dart';
import 'package:g2g/screens/homeScreen.dart';
import 'package:g2g/screens/twakToScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
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
        child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
        DrawerHeader(
          child: Container(),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage('images/logo.png'),alignment: Alignment.center)
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_box,size: _isLarge?28:24,),
          title: Text('Edit Profile',style: TextStyle(fontSize:_isLarge?22:18),),
          onTap: () async{
            final pr =ProgressDialog(context);
            pr.show();
            ClientController().getClientBasic().then((clientData) {pr.hide();Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>EditProfile(clientData)),(r)=>r.isFirst);});
          },
        ),
        ListTile(
          leading: Icon(Icons.folder,size: _isLarge?28:24,),
          title: Text('Documents',style: TextStyle(fontSize:_isLarge?22:18),),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.local_atm,size: _isLarge?28:24,),
          title: Text('My Loans',style: TextStyle(fontSize:_isLarge?22:18),),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.forum,size: _isLarge?28:24,),
          title: Text('Connect',style: TextStyle(fontSize:_isLarge?22:18),),
          onTap: () async{
            // launch('https://tawk.to/chat/5f3278b420942006f46a9dc2/default',forceSafariVC: true,forceWebView: true);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TawkToScreen()),(r)=>r.isFirst);
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
          leading: Icon(Icons.vpn_key,size: _isLarge?28:24,),
          title: Text('Reset Password',style: TextStyle(fontSize:_isLarge?22:18),),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: FlatButton(onPressed: (){}, child: Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text('Apply',style: TextStyle(fontSize:_isLarge?24:20,color: Colors.white,fontWeight: FontWeight.bold),),
          ),color: kPrimaryColor,),
        )
    ],
  ),
      ),
    );
  }
}