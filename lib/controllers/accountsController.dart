import 'dart:convert';
import 'dart:io';
import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:http/http.dart' as http;

class AccountsController {
  Future<List<Account>> getAccounts(String clientID,String sessionToken) async {
    List<Account> accounts = [];
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
      accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Quote') accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Closed') accounts.add(Account.fromJson(m));
    return accounts;
  }
}
