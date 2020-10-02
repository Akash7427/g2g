import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/resetController.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/utility/hashSha256.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with SingleTickerProviderStateMixin {
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final userID = TextEditingController();
  final emailID = TextEditingController();
  final mobileNumber = TextEditingController();
  final resetController = ResetController();
  final accountsController = AccountsController();
  bool _autoValidate = false;
  AnimationController animationController;
  Animation animation;
  final userIDNode = FocusNode();
  final emailIDNode = FocusNode();
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
          child: ListView(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 10, left: 20, right: 20.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'images/logo2.png',
                        height: _isLarge ? 400 : 150,
                      ),
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          autovalidate: _autoValidate,
                          key: _resetPasswordFormKey,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildFormField(Icons.person_outline, userID,
                                    'UserID', userIDNode, emailIDNode),
                                SizedBox(height: 15),
                                buildFormField(Icons.person_outline, emailID,
                                    'Email Address', emailIDNode, pwdNode),
                                SizedBox(height: 15),
                                buildFormField(Icons.call, mobileNumber,
                                    'Mobile Number', pwdNode, null,
                                    obscureText: false),
                                SizedBox(height: 10),
                                Container(
                                  child: RaisedButton(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Reset'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: _isLarge ? 26 : 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    color: kPrimaryColor,
                                    // padding: EdgeInsets.only(
                                    //     top: 15, bottom: 15, left: 15, right: 15),
                                    onPressed: () async {
                                      if (_resetPasswordFormKey.currentState
                                          .validate()) {
                                        final pr = ProgressDialog(context,
                                            isLogin: true);
                                        setState(() {
                                          pr.show();
                                        });

                                        resetController
                                            .authenticateClient(userID.text,
                                                emailID.text, mobileNumber.text)
                                            .then(
                                          (reset) async {
                                            if (reset.IsExisting == 'FALSE') {
                                              pr.hide();
                                              Alert(
                                                  context: context,
                                                  title: '${reset.Message}',
                                                  type: AlertType.error,
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: _isLarge
                                                                ? 24
                                                                : 18),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: kPrimaryColor,
                                                      radius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ],
                                                  style: AlertStyle(
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    isCloseButton: false,
                                                    isOverlayTapDismiss: false,
                                                    titleStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            _isLarge ? 24 : 18),
                                                  )).show();
                                            } else {
                                              Alert(
                                                  context: context,
                                                  title: '${reset.Message}',
                                                  type: AlertType.success,
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: _isLarge
                                                                ? 24
                                                                : 18),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: kPrimaryColor,
                                                      radius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ],
                                                  style: AlertStyle(
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    isCloseButton: false,
                                                    isOverlayTapDismiss: false,
                                                    titleStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            _isLarge ? 24 : 18),
                                                  )).show();
                                              pr.hide();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()),
                                                  (route) => false);
                                            }
                                          },
                                        );
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget buildFormField(IconData icon, TextEditingController controller,
      String labelText, FocusNode fNode, FocusNode nextNode,
      {bool obscureText = false}) {
    return Container(
      child: TextFormField(
        cursorColor: kPrimaryColor,
        inputFormatters: obscureText ? null : [],
        validator: (value) {
          if (value.isEmpty)
            return obscureText ? 'Password Required' : 'ID Required';
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
