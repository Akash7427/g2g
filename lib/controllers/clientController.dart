import 'dart:convert';

import 'package:g2g/constants.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/utility/hashSha256.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripledes/tripledes.dart';
import 'package:xml2json/xml2json.dart';

class ClientController {
  Future<String> authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = 'WEBSERVICES';
    var password = 'G2GW3bs3rv1c35';
    Map hashAndSalt = hashSHA256(userID + password);
    print(
        '$apiBaseURL/Authentication/AuthenticateUser?subscriberId=$subscriberID&userId=$userID&password=$password&hash=${hashAndSalt['hash']}&hashSalt=${hashAndSalt['salt']}');

    http.Response response = await http.get(
        '$apiBaseURL/Authentication/AuthenticateUser?subscriberId=$subscriberID&userId=$userID&password=$password&hash=${hashAndSalt['hash']}&hashSalt=${hashAndSalt['salt']}');
    print(response.body);
    var webUserResponse = jsonDecode(response.body);
    if (webUserResponse['SessionToken'] != null) {
      prefs.setString(
          PrefHelper.PREF_AUTH_TOKEN, webUserResponse['SessionToken']);

      // prefs.setString('user', response.body);
      return webUserResponse['SessionToken'];
    } else if (webUserResponse["Code"] == "Subscriber.InvalidHash") {
      return await authenticateUser();
    }
    return null;
  }

  getEncryptPassword(String passw) {
    String key = "#finPOWERTesting@!@#\\\$##";

    print(key);

    var blockCipher = BlockCipher(TripleDESEngine(), key);

    var ciphertext = blockCipher.encodeB64(passw);
    print(ciphertext);
    return ciphertext;
  }

  Future<Client> authenticateClient(clientID, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final myTransformer = Xml2Json();

    String data =
        '<ClientAuthentication><UserID>$clientID</UserID><Password>${getEncryptPassword(password)}</Password></ClientAuthentication>';

    http.Response response = await http.post(
        'https://wstest.goodtogoloans.com.au/api/custom/ClientLogin',
        body: data,
        headers: {
          'content-Type': 'text/xml',
          'Authorization':
              'AuthFinWs token="${prefs.getString(PrefHelper.PREF_AUTH_TOKEN)}"'
        });

    myTransformer.parse(response.body); //xml parsed
    print(prefs.getString(PrefHelper.PREF_AUTH_TOKEN));
    print(myTransformer.xmlParserResult);
    var json = myTransformer.toParker();
    var data1 = jsonDecode(json);

    print(data1);
    print(data1['ClientAuthentication']['SessionDetails']['SessionToken']);

    if (data1['ClientAuthentication']['LoginSucess'] != 'FALSE') {
      if (data1['ClientAuthentication']['SessionDetails']['SessionToken'] !=
          null) {
        prefs.setBool('isLoggedIn', true);
        prefs.setString('clientID', clientID);
        prefs.setString('password', password);
        prefs.setString('SessionToken',
            data1['ClientAuthentication']['SessionDetails']['SessionToken']);
      }
      // prefs.setString('user', data1);
      return Client.fromJson(data1);
    } else if (data1['ClientAuthentication']['LoginSuccess'] == 'FALSE') {
      return await authenticateClient(clientID, password);
    } else {
      return null;
    }
  }

  Future<Map> getClientBasic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http
        .get('$apiBaseURL/Client/GetClientBasic?clientId=C220032', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'AuthFinWs token="${prefs.getString('SessionToken')}"'
    });
    print(response.body);
    return jsonDecode(response.body);
  }
}
