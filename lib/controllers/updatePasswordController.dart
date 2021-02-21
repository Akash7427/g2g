import 'dart:convert';

import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/models/updatePasswordModel.dart';
import 'package:g2g/utility/hashSha256.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g2g/screens/loginScreen.dart';


class UpdatePasswordController with ChangeNotifier{
  Future<UpdatePassword> updatePassword(
      // userID, emailID,
      mobileNumber,
      password) async {
    await ClientController().authenticateUser();
    await ClientController().getClientBasic();

    final myTransformer = Xml2Json();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString(PrefHelper.PREF_USER_ID);
    var emailID = prefs.getString(PrefHelper.PREF_EMAIL_ID);
    print(getEncryptPassword(password));
    print(userID.toString());
    print(prefs.getString(PrefHelper.PREF_AUTH_TOKEN).toString());


    String data =
        '<PasswordReset><UserID>$userID</UserID><EmailAddress>$emailID</EmailAddress><Mobile>$mobileNumber</Mobile><Password>${getEncryptPassword(password)}</Password></PasswordReset>';
print(data);
    http.Response response = await http.post(
        'https://wstest.goodtogoloans.com.au/api/custom/UpdatePassword',
        body: data,
        headers: {
          'content-Type': 'text/plain',
          'Authorization':
              'AuthFinWs token="${prefs.getString(PrefHelper.PREF_AUTH_TOKEN)}"'
        });

    myTransformer.parse(response.body); //xml parsed
    var json = myTransformer.toParker();
    var data1 = jsonDecode(json)['PasswordReset'];
    print(data1);
    UpdatePassword updatePassword = UpdatePassword.fromJson(data1);
    return updatePassword;
  }


  Future<void> logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final secureStorage = new FlutterSecureStorage();
    await preferences.clear();
    await secureStorage.deleteAll();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
