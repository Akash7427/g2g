import 'dart:convert';

import 'package:g2g/models/updatePasswordModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

class UpdatePasswordController {
  Future<UpdatePassword> updatePassword(
      userID, emailID, mobileNumber, password) async {
    final myTransformer = Xml2Json();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data =
        '<ValidateClient> <UserID>$userID</UserID> <EmailAddress>$emailID</EmailAddress> <Mobile>$mobileNumber</Mobile><Password>$password</Password></ValidateClient>';

    http.Response response = await http.post(
        'https://wstest.goodtogoloans.com.au/api/custom/UpdatePassword',
        body: data,
        headers: {
          'content-Type': 'text/xml',
          'Authorization':
              'AuthFinWs token="${prefs.getString('SessionToken')}"'
        });

    myTransformer.parse(response.body); //xml parsed

    print(myTransformer.xmlParserResult);
    var json = myTransformer.toParker();
    var data1 = jsonDecode(json);
    print(data1);
    return UpdatePassword.fromJson(data1);
  }
}
