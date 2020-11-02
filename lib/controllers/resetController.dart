import 'dart:convert';

import 'package:g2g/models/resetPasswordModel.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

class ResetController {
  Future<ResetPassword> authenticateClient(
      userID, emailID, mobileNumber) async {
    final myTransformer = Xml2Json();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String data =
        '<ValidateClient> <UserID>$userID</UserID> <EmailAddress>$emailID</EmailAddress> <Mobile>$mobileNumber</Mobile></ValidateClient>';

    http.Response response = await http.post(
        'https://wstest.goodtogoloans.com.au/api/custom/AppResetPassword',
        body: data,
        headers: {
          'content-Type': 'text/xml',
          'Authorization':
              'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"'
        });

    myTransformer.parse(response.body); //xml parsed

    print(myTransformer.xmlParserResult);
    var json = myTransformer.toParker();
    var data1 = jsonDecode(json);
    print(data1);
    return ResetPassword.fromJson(data1);
  }
}
