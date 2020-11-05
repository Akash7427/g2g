import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/clientBasicModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/utility/custom_formbuilder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import'package:g2g/utility/input_decoration.dart';

class EditProfile extends StatefulWidget {
  ClientBasicModel data;
  EditProfile(this.data);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey=GlobalKey<ScaffoldState>();

  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();



  // @override
  // void initState(){
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_){
  //     Provider.of<ClientController>(context,listen: false).getClientBasic().then((value) {
  //       data = value;
  //     } );
  //
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    final firstNameNode = FocusNode();
    final lastNameNode = FocusNode();
    final emailNode = FocusNode();
    final mobileNoNode = FocusNode();
    final homePhoneNoNode = FocusNode();
    final workPhoneNoNode = FocusNode();
    final streetAddressNode = FocusNode();
    final suburbNode = FocusNode();
    final postCodeNode = FocusNode();

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
      body: SafeArea(child:

           Container(
          padding: EdgeInsets.all(10),
          child:  Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
              elevation: 10,
                shadowColor: kPrimaryColor,
              child: Padding(
                padding: EdgeInsets.all(19),
                child: GestureDetector(
                  onPanDown: (_){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: FormBuilder(key: _fbKey,
                  initialValue: {
                    'first_name':splitName(widget.data.name, '1'),
                    'last_name':splitName(widget.data.name, '2'),
                    'email':widget.data.contactMethodEmail,
                    'mobile_no':widget.data.contactMethodMobile,
                    'home_phone_no':widget.data.contactMethodPhoneHome,
                    'work_phone_no':widget.data.contactMethodPhoneWork,
                    'street_address':widget.data.streetAddressFull,
                    'suburb':widget.data.suburb,
                    'post_code':widget.data.postCode,


                  },
                  readOnly: false,child: ListView(children: [
                        !_isLarge?
                        Column(
                          children: [
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              focusNode: firstNameNode,
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "first_name",
                              decoration: buildInputDecoration(
                                context,
                                 "First Name","Enter First Name"),
                              onFieldSubmitted: (value) {
                                lastNameNode.requestFocus();
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              validators: [
                                FormBuilderValidators.min(3),
                                CustomFormBuilderValidators.charOnly(),
                                FormBuilderValidators.maxLength(20),
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(3),
                              ],
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              focusNode: lastNameNode,
                              onFieldSubmitted: (value) {
                                emailNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "last_name",
                              textInputAction: TextInputAction.next,
                              decoration: buildInputDecoration(
                                 context, "Last Name","Enter Last Name"),
                              keyboardType: TextInputType.text,
                              validators: [
                                CustomFormBuilderValidators.charOnly(),
                                FormBuilderValidators.minLength(3),
                                FormBuilderValidators.maxLength(20),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: emailNode,
                              onFieldSubmitted: (value) {
                                mobileNoNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),

                                fontFamily: "Montserrat",
                              ),
                              attribute: "email",
                              decoration: buildInputDecoration(
                                context, "Email Address","Enter Email Address"),
                              keyboardType: TextInputType.emailAddress,
                              validators: [
                                FormBuilderValidators.email(),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height:20),
                            FormBuilderTextField(
                              focusNode: mobileNoNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                homePhoneNoNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "mobile_no",
                              maxLength: 11,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: buildInputDecoration(
                                 context, "Mobile Number", "Enter Mobile Number"),
                              keyboardType: TextInputType.number,
                              validators: [
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.minLength(10),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              focusNode: homePhoneNoNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                workPhoneNoNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "home_phone_no",
                              maxLength: 15,
                              decoration: buildInputDecoration(
                                  context,"Ph Home","Phone Number(Home)"),
                              keyboardType: TextInputType.number,
                              validators: [

                                FormBuilderValidators.minLength(10),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              focusNode: workPhoneNoNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                streetAddressNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "work_phone_no",
                              maxLength: 10,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: buildInputDecoration(
                                 context,"Ph Work", "Phone Number(Work)"),
                              keyboardType: TextInputType.number,
                              validators: [
                                FormBuilderValidators.numeric(),
                                FormBuilderValidators.minLength(10),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height: 20,),
                            FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: streetAddressNode,
                              onFieldSubmitted: (value) {
                                suburbNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "street_address",
                              decoration: buildInputDecoration(
                                   context,"Address","Enter Street Address"),
                              keyboardType: TextInputType.text,
                              validators: [
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height:20),
                            FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: suburbNode,
                              onFieldSubmitted: (value) {
                                postCodeNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "suburb",
                              decoration: buildInputDecoration(
                                  context,"Suburb","Enter Suburb"),
                              keyboardType: TextInputType.text,
                              validators: [
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height:20),
                            FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: postCodeNode,
                              onFieldSubmitted: (value) {

                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "post_code",
                              decoration: buildInputDecoration(
                                  context,"Postcode","Enter PostCode"),
                              keyboardType: TextInputType.text,
                              validators: [
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height:20),


                          ],
                        ):Column(
                          children: [
                            SizedBox(height: 30,),
                            Row(children: [

                              Expanded(child:    FormBuilderTextField(
                                focusNode: firstNameNode,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontFamily: "Montserrat",
                                ),
                                attribute: "first_name",
                                decoration: buildInputDecoration(
                                  context,"First Name", "Enter First Name"),
                                onFieldSubmitted: (value) {
                                  lastNameNode.requestFocus();
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validators: [
                                  FormBuilderValidators.min(3),
                                  CustomFormBuilderValidators.charOnly(),
                                  FormBuilderValidators.maxLength(20),
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(3),
                                ],
                              )),
                              SizedBox(width: 10,),
                              Expanded(child: FormBuilderTextField(
                                focusNode: lastNameNode,
                                onFieldSubmitted: (value) {
                                  emailNode.requestFocus();
                                },
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontFamily: "Montserrat",
                                ),
                                attribute: "last_name",
                                textInputAction: TextInputAction.next,
                                decoration: buildInputDecoration(
                                    context,"Last Name","Enter Last Name"),
                                keyboardType: TextInputType.text,
                                validators: [
                                  CustomFormBuilderValidators.charOnly(),
                                  FormBuilderValidators.minLength(3),
                                  FormBuilderValidators.maxLength(20),
                                  FormBuilderValidators.required()
                                ],
                              )),

                            ],),
                            SizedBox(height: 30,),
                            Row(
                              children: [
                                Expanded(child:FormBuilderTextField(
                                  textInputAction: TextInputAction.next,
                                  focusNode: emailNode,
                                  onFieldSubmitted: (value) {
                                    mobileNoNode.requestFocus();
                                  },
                                  style: TextStyle(
                                    color: Color(0xff222222),

                                    fontFamily: "Montserrat",
                                  ),
                                  attribute: "email",
                                  decoration: buildInputDecoration(
                                     context, "Email Address","Enter Email Address"),
                                  keyboardType: TextInputType.emailAddress,
                                  validators: [
                                    FormBuilderValidators.email(),
                                    FormBuilderValidators.required()
                                  ],
                                ),),
                                SizedBox(width: 10,),
                                Expanded(child:   FormBuilderTextField(
                                  focusNode: mobileNoNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    homePhoneNoNode.requestFocus();
                                  },
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontFamily: "Montserrat",
                                  ),
                                  attribute: "mobile_no",
                                  maxLength: 11,
                                  decoration: buildInputDecoration(
                                     context,"Mobile Number","Enter Mobile Number"),
                                  keyboardType: TextInputType.number,
                                  validators: [

                                    FormBuilderValidators.minLength(10),
                                    FormBuilderValidators.required()
                                  ],
                                ),)
                              ],
                            ),
                            SizedBox(height:30),
                            Row(children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  focusNode: homePhoneNoNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    workPhoneNoNode.requestFocus();
                                  },
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontFamily: "Montserrat",
                                  ),
                                  attribute: "home_phone_no",
                                  maxLength: 15,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: buildInputDecoration(
                                     context,"Ph Home", "Phone Number(Home)"),
                                  keyboardType: TextInputType.number,
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.minLength(10),
                                    FormBuilderValidators.required()
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: FormBuilderTextField(
                                  focusNode: workPhoneNoNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    streetAddressNode.requestFocus();
                                  },
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontFamily: "Montserrat",
                                  ),
                                  attribute: "work_phone_no",
                                  maxLength: 10,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: buildInputDecoration(
                                     context,"Ph Work", "Phone Number(Work)"),
                                  keyboardType: TextInputType.number,
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.minLength(10),
                                    FormBuilderValidators.required()
                                  ],
                                ),
                              )


                            ],),
                            SizedBox(height:30),
                            FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: streetAddressNode,
                              onFieldSubmitted: (value) {
                                suburbNode.requestFocus();
                              },
                              style: TextStyle(
                                color: Color(0xff222222),
                                fontFamily: "Montserrat",
                              ),
                              attribute: "street_address",
                              decoration: buildInputDecoration(
                                  context,"Address", "Enter Street Address"),
                              keyboardType: TextInputType.text,
                              validators: [
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.required()
                              ],
                            ),
                            SizedBox(height:30),
                            Row(children: [
                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: suburbNode,
                                onFieldSubmitted: (value) {
                                  postCodeNode.requestFocus();
                                },
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontFamily: "Montserrat",
                                ),
                                attribute: "suburb",
                                decoration: buildInputDecoration(
                                    context,"Suburb", "Enter Suburb"),
                                keyboardType: TextInputType.text,
                                validators: [
                                  FormBuilderValidators.maxLength(50),
                                  FormBuilderValidators.required()
                                ],
                              ),

                              FormBuilderTextField(
                                textInputAction: TextInputAction.next,
                                focusNode: postCodeNode,
                                onFieldSubmitted: (value) {

                                },
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontFamily: "Montserrat",
                                ),
                                attribute: "post_code",
                                decoration: buildInputDecoration(
                                    context,"Postcode", "Enter PostCode"),
                                keyboardType: TextInputType.text,
                                validators: [
                                  FormBuilderValidators.maxLength(50),
                                  FormBuilderValidators.required()
                                ],
                              ),

                            ],)

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
                                    var pr = ProgressDialog(context);
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      print(_fbKey.currentState.value);

                                      pr.show();
                                      Provider.of<ClientController>(context,listen:false).postClientBasic(_fbKey.currentState.value).then((value){
                                        pr.hide();

                                        _editProfileKey.currentState.showSnackBar(SnackBar(content: Text(value['message']),));



                                      });
                                    } else {
                                      print(_fbKey.currentState.value);
                                      print('validation failed');
                                      pr.hide();
                                    }
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


                  ],)),
                )

              ),
            ),

          height:double.infinity,width:double.infinity, decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/bg.jpg'),fit: BoxFit.cover)
            ),)),
    );
  }



  String splitName(String name, flag){
    List<String> listName = name.split(' ');

    switch(flag){
      case '1':
        return listName[listName.length-1];
      break;
      case '2':
        return listName[0];
        break;

    }

  }
}