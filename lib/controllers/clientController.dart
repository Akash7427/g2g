import 'dart:convert';
import 'dart:io';

import 'package:g2g/models/clientModel.dart';
import 'package:g2g/utility/hashSha256.dart';

import 'package:g2g/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ClientController{
   Future<Client> authenticateClient(clientID,password)async{
     SharedPreferences prefs=await SharedPreferences.getInstance();
     Map hashAndSalt =hashSHA256(clientID + password);
     http.Response response=await http.get('$apiBaseURL/Authentication/AuthenticateClient?subscriberId=$subscriberID&clientId=$clientID&password=$password&hash=${hashAndSalt['hash']}&hashSalt=${hashAndSalt['salt']}');
    print(response.body);
    if (jsonDecode(response.body)['SessionToken'] !=null){
      prefs.setBool('isLoggedIn',true);
      prefs.setString('clientID',clientID);
      prefs.setString('password',password);
      // prefs.setString('user', response.body);
      return Client.fromJson(jsonDecode(response.body));
    }
    else if (jsonDecode(response.body)["Code"] =="Subscriber.InvalidHash"){
       return await authenticateClient(clientID,password);
    }
    else{return null;}
  }
  Future<Map> getClientBasic()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    http.Response response=await http.get('$apiBaseURL/Client/GetClientBasic?clientId=${prefs.getString('clientID')}',headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'AuthFinWs token="${jsonDecode(prefs.getString('user'))['SessionToken']}"'
        });
    print(response.body);
    return jsonDecode(response.body);
  }
}