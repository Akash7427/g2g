import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfile extends StatefulWidget {
  final Map clientData;
  EditProfile(this.clientData);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey=GlobalKey<ScaffoldState>();
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
       key: _editProfileKey,
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
                        radius:BorderRadius.circular(10),
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
        title: Text('Edit Profile',
            style: TextStyle(
                fontSize: _isLarge?28:22,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _editProfileKey.currentState.openDrawer();
          },
        ),
      ),
      body: SafeArea(child: Container(
        padding: EdgeInsets.all(10),
        child:  Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
            elevation: 10,
              shadowColor: kPrimaryColor,
            child: Padding(
              padding: EdgeInsets.all(19),
              child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    !_isLarge?
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        buildTextField('First Name',widget.clientData['Name'].split(', ')[1]),
                        SizedBox(height: 20,),
                        buildTextField('Last Name',widget.clientData['Name'].split(', ')[0]),
                        
                      ],
                    ):Column(
                      children: [
                        SizedBox(height: 30,),
                        Row(children: [
                          
                            Expanded(child: buildTextField('First Name',widget.clientData['Name'].split(', ')[1])),
                            SizedBox(width: 10,),
                            Expanded(child: buildTextField('Last Name',widget.clientData['Name'].split(', ')[0])),
                            
                        ],),
                        SizedBox(height: 30,),
                      ],
                    ),
                   !_isLarge?
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        buildTextField('Email',widget.clientData["ContactMethodEmail"]),
                        SizedBox(height: 20,),
                        buildTextField('Mobile Number',widget.clientData['ContactMethodMobile'],numbersOnly: true),
                        
                      ],
                    ):Column(
                      children: [
                        SizedBox(height: 30,),
                        Row(children: [
                          
                            Expanded(child: buildTextField('Email',widget.clientData["ContactMethodEmail"])),
                            SizedBox(width: 10,),
                            Expanded(child: buildTextField('Mobile Number',widget.clientData['ContactMethodMobile'],numbersOnly: true)),
                            
                        ],),
                        SizedBox(height: 30,),
                      ],
                    ),
                    !_isLarge?
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        buildTextField('Phone Number (Home)',widget.clientData["ContactMethodPhoneHome"]),
                        SizedBox(height: 20,),
                        buildTextField('Phone Number (Work)',widget.clientData['ContactMethodPhoneWork'],numbersOnly: true),
                        SizedBox(height: 20,),
                      ],
                    ):Column(
                      children: [
                        SizedBox(height: 30,),
                        Row(children: [
                          
                            Expanded(child: buildTextField('Phone Number (Home)',widget.clientData["ContactMethodPhoneHome"])),
                            SizedBox(width: 10,),
                            Expanded(child: buildTextField('Phone Number (Work)',widget.clientData['ContactMethodPhoneWork'],numbersOnly: true)),
                            
                        ],),
                        SizedBox(height: 30,),
                      ],
                    ),
                    buildTextField('Street Address',widget.clientData["AddressPhysical"]['StreetAddressFull']),
                    !_isLarge?
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        buildTextField('Suburb',widget.clientData["AddressPhysical"]["Suburb"]),
                        SizedBox(height: 20,),
                        buildTextField('Postcode',widget.clientData["AddressPhysical"]["Postcode"],numbersOnly: true),
                        SizedBox(height: 35,),
                      ],
                    ):Column(
                      children: [
                        SizedBox(height: 30,),
                        Row(children: [
                          
                            Expanded(child: buildTextField('Suburb',widget.clientData["AddressPhysical"]["Suburb"])),
                            SizedBox(width: 10,),
                            Expanded(child: buildTextField('Postcode',widget.clientData["AddressPhysical"]["Postcode"],numbersOnly: true)),
                            
                        ],),
                        SizedBox(height: 35,),
                      ],
                    ),
                    
                    
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Expanded(
                                 child: FlatButton(
                                  color: Colors.grey[700],
                                  onPressed: (){
                                  Navigator.pop(context);
                                }, child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('BACK',
                                      style: TextStyle(
                                          fontSize: _isLarge ? 25 : 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                )),
                         ),
                              SizedBox(width:5),
                         Expanded(
                                                    child: FlatButton(
                                  color: kSecondaryColor,
                                  onPressed: (){

                                }, child: Padding(
                                  padding:  EdgeInsets.all(12.0),
                                  child: Text('SAVE',
                                      style: TextStyle(
                                          fontSize: _isLarge ? 25 : 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                )),
                         ),
                       ],
                     )
                  ],
                ),
              ),
            ),
          ),
        
        height:double.infinity,width:double.infinity, decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/bg.jpg'),fit: BoxFit.cover)
          ),)),
    );
  }

  TextFormField buildTextField(String labelText,String initialValue,{bool numbersOnly=false}) {
    return TextFormField(
      keyboardType: numbersOnly?TextInputType.number:TextInputType.name,
                 decoration:InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(15)),
                focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(15)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(15)),
            
            labelText: labelText,
            labelStyle: TextStyle(
                fontSize: _isLarge ? 24 : 18, color: Colors.black)), 
                initialValue: initialValue,
                style: TextStyle(fontSize: _isLarge ? 24 : 18, color: Colors.black),
                );
  }
}