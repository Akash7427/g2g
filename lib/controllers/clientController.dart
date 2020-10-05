import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:http/http.dart' as http;

class AccountsController with ChangeNotifier{
  List<Account> _accounts = [];
  Future<List<Account>> getAccounts(String clientID,String sessionToken) async {
    
    http.Response response = await http.get(
        '$apiBaseURL/Client/GetAccounts?clientId=$clientID&includeQuote=true&includeOpen=true&includeClosed=true',
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'AuthFinWs token="$sessionToken"'
        });
        print(clientID);
        print(response.body);
    for (Map m in jsonDecode(response.body))
      if (m['Status'] == 'Open') 
      _accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Quote') _accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Closed') _accounts.add(Account.fromJson(m));
      notifyListeners();
    return _accounts;
  }

List<Account>  getAccountsList(){
  return [... _accounts];
}
  




}
