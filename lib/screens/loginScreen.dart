import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/applyNow_CalcScreen.dart';
import 'package:g2g/screens/homeScreen.dart';
import 'package:g2g/screens/resetPassword.dart';
import 'package:g2g/utility/hashSha256.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final clientID = TextEditingController();
  final password = TextEditingController();

  bool _autoValidate = false;
  AnimationController animationController;
  Animation animation;
  final userIDNode = FocusNode();
  final pwdNode = FocusNode();
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    tripleDES();
    // animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // animation =
    //     CurvedAnimation(parent: animationController, curve: Curves.bounceIn);
    // animationController.forward();
    // animationController.addListener(() {
    //   setState(() {});
    //   // print(animationController.value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
            child: SafeArea(
                child: GestureDetector(
                  onPanDown: (_) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(child:  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8),
                        Image.asset(
                          'images/logo2.png',
                          height: _isLarge ? 400 : 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Log in to your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Form(
                            autovalidate: _autoValidate,
                            key: _loginFormKey,
                            child: Card(
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildFormField(Icons.person_outline, clientID,
                                      'Email', userIDNode, pwdNode),
                                  SizedBox(height: 15),
                                  buildFormField(Icons.lock, password, 'Password',
                                      pwdNode, null,
                                      obscureText: true),
                                  SizedBox(height: 40),
                                  Container(
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
                                      child: Text(
                                        'Login'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: _isLarge ? 26 : 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      color: kPrimaryColor,
                                      // padding: EdgeInsets.only(
                                      //     top: 15, bottom: 15, left: 15, right: 15),
                                      onPressed: () async {
                                        if (_loginFormKey.currentState
                                            .validate()) {
                                          final pr = ProgressDialog(context,
                                              isLogin: true);
                                          setState(() {
                                            pr.show();
                                          });

                                          Provider.of<ClientController>(context,
                                              listen: false)
                                              .authenticateUser()
                                              .then((value) async {
                                            if (value == null) {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Something went wrong please try again!'),
                                              ));
                                              return;
                                            }
                                            Provider.of<ClientController>(context,
                                                listen: false)
                                                .authenticateClient(clientID.text,
                                                password.text, false)
                                                .then(
                                                  (user) async {
                                                if (user == null) {
                                                  pr.hide();
                                                  Alert(
                                                      context: context,
                                                      title: '',
                                                      content: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            ClipOval(
                                                              child: Material(
                                                                color: Colors.red, // button color
                                                                child: SizedBox(width: 56, height: 56, child: Icon(Icons.close,color:Colors.white)),
                                                              ),
                                                            ),
                                                            SizedBox(height:20),
                                                            Text('Invalid Password'),]),
                                                      buttons: [
                                                        DialogButton(
                                                          child: Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontSize: _isLarge
                                                                    ? 24
                                                                    : 18),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          color: kPrimaryColor,
                                                          radius: BorderRadius
                                                              .circular(0.0),
                                                        ),
                                                      ],
                                                      style: AlertStyle(
                                                        animationType:
                                                        AnimationType.fromTop,
                                                        isCloseButton: false,
                                                        isOverlayTapDismiss:
                                                        false,
                                                        titleStyle: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: _isLarge
                                                                ? 24
                                                                : 18),
                                                      )).show();
                                                } else {
                                                  Provider.of<AccountsController>(
                                                      context,
                                                      listen: false)
                                                      .getAccounts(user.userID,
                                                      user.sessionToken)
                                                      .then((accounts) {
                                                    pr.hide();
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>

                                                                HomeScreen(),settings: RouteSettings(
                                                          arguments: 1,
                                                        )),
                                                            (route) => false);

                                                  });
                                                }
                                              },
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            _autoValidate = true;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        FlatButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ResetPassword()));

                          },
                          child: Text(
                            'Forgot Password?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                                fontSize: 20
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Are you a new Customer?',style: TextStyle(fontSize: _isLarge ? 26 : 20,fontWeight: FontWeight.w900,color: Colors.black54),),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ApplyNowForLoan()));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                 /* decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xFF17477A),
                                  ),*/
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 16),
                                  child: Text(
                                    'Apply Now'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:Color(0xFF17477A),
                                      fontSize: _isLarge ? 26 : 20,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

              ],
            ),),
          )
        ],
      ),
    );
  }

  Widget buildFormField(IconData icon, TextEditingController controller,
      String labelText, FocusNode fNode, FocusNode nextNode,
      {bool obscureText = false}) {
    return Container(
      child: TextFormField(
        cursorColor: kPrimaryColor,
        inputFormatters: obscureText
            ? null
            : [
          LowerCaseTextFormatter(),
        ],

        validator: (value) {
          if (value.isEmpty)
            return obscureText ? 'Password Required' : 'Email ID Required';
          return null;
        },
        textInputAction:
        nextNode != null ? TextInputAction.next : TextInputAction.done,
        // textCapitalization: obscureText
        //     ? TextCapitalization.sentences
        //     : TextCapitalization.characters,
        obscureText: obscureText,
        focusNode: fNode,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            prefixIcon:
            Icon(icon, color: kPrimaryColor, size: _isLarge ? 30 : 24),
            hintText: labelText,
            hintStyle:
            TextStyle(fontSize: _isLarge ? 24 : 18, color: Colors.black54)),
        style: TextStyle(
          fontSize: _isLarge ? 24 : 18,
          color: Colors.black,
        ),
        onFieldSubmitted: (value) {
          if (nextNode != null) nextNode.requestFocus();
        },
        controller: controller,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
