import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/homeScreen.dart';
import 'package:g2g/utility/hashSha256.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final clientID = TextEditingController();
  final password = TextEditingController();
  final clientController = ClientController();
  final accountsController = AccountsController();
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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
        child: SafeArea(
            child: GestureDetector(
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(_isLarge ? 50 : 8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              'images/logo.png',
                                              width: _width * 0.9,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 28.0),
                                              child: Divider(
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 0),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Form(
                                                  autovalidate: _autoValidate,
                                                  key: _loginFormKey,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        _isLarge ? 45 : 8.0),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                      color: kPrimaryColor,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10.0,
                                                                horizontal:
                                                                    _isLarge
                                                                        ? 40
                                                                        : 15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0.0),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            20.0),
                                                                child: Text(
                                                                  'EXISTING CUSTOMER',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _isLarge
                                                                              ? 28
                                                                              : 22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            buildFormField(
                                                                Icons
                                                                    .account_circle,
                                                                clientID,
                                                                'Client ID',
                                                                userIDNode,
                                                                pwdNode),
                                                            buildFormField(
                                                                Icons.vpn_key,
                                                                password,
                                                                'Password',
                                                                pwdNode,
                                                                null,
                                                                obscureText:
                                                                    true),
                                                            SizedBox(
                                                                height: 10),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          _isLarge
                                                                              ? 40
                                                                              : 20),
                                                              child:
                                                                  RaisedButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                onPressed:
                                                                    () async {
                                                                  if (_loginFormKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    final pr = ProgressDialog(
                                                                        context,
                                                                        isLogin:
                                                                            true);
                                                                    setState(
                                                                        () {
                                                                      pr.show();
                                                                    });

                                                                    clientController
                                                                        .authenticateClient(
                                                                            clientID
                                                                                .text,
                                                                            password
                                                                                .text)
                                                                        .then(
                                                                            (user) async {
                                                                      if (user ==
                                                                          null) {
                                                                        pr.hide();
                                                                        Alert(
                                                                            context:
                                                                                context,
                                                                            title:
                                                                                'Invalid Credentials',
                                                                            type:
                                                                                AlertType.error,
                                                                            buttons: [
                                                                              DialogButton(
                                                                                child: Text(
                                                                                  "Close",
                                                                                  style: TextStyle(color: Colors.white, fontSize: _isLarge ? 24 : 18),
                                                                                ),
                                                                                onPressed: () => Navigator.pop(context),
                                                                                color: kPrimaryColor,
                                                                                radius: BorderRadius.circular(0.0),
                                                                              ),
                                                                            ],
                                                                            style: AlertStyle(
                                                                              animationType: AnimationType.fromTop,
                                                                              isCloseButton: false,
                                                                              isOverlayTapDismiss: false,
                                                                              titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: _isLarge ? 24 : 18),
                                                                            )).show();
                                                                      } else {
                                                                        accountsController
                                                                            .getAccounts(clientID.text,
                                                                                user.sessionToken)
                                                                            .then((accounts) {
                                                                          pr.hide();
                                                                          Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => HomeScreen(user, accounts)),
                                                                              (route) => false);
                                                                        });
                                                                      }
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _autoValidate =
                                                                          true;
                                                                    });
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Text(
                                                                    'Login'
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: _isLarge
                                                                            ? 26
                                                                            : 20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            kPrimaryColor),
                                                                  ),
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Forgot Password?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    _isLarge
                                                                        ? 24
                                                                        : 16,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget buildFormField(IconData icon, TextEditingController controller,
      String labelText, FocusNode fNode, FocusNode nextNode,
      {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          cursorColor: kPrimaryColor,
          inputFormatters: obscureText
              ? null
              : [
                  UpperCaseTextFormatter(),
                ],
          validator: (value) {
            if (value.isEmpty)
              return obscureText ? 'Password Required' : 'Client ID Required';
            return null;
          },
          textInputAction:
              nextNode != null ? TextInputAction.next : TextInputAction.done,
          textCapitalization: obscureText
              ? TextCapitalization.sentences
              : TextCapitalization.characters,
          obscureText: obscureText,
          focusNode: fNode,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              prefixIcon:
                  Icon(icon, color: kPrimaryColor, size: _isLarge ? 30 : 24),
              hintText: labelText,
              hintStyle: TextStyle(
                  fontSize: _isLarge ? 24 : 18, color: Colors.black54)),
          style: TextStyle(fontSize: _isLarge ? 24 : 18, color: Colors.black),
          onFieldSubmitted: (value) {
            if (nextNode != null) nextNode.requestFocus();
          },
          controller: controller,
        ),
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
