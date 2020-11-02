import 'dart:convert';

import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountsController with ChangeNotifier {
  List<Account> _accounts = [];

  Future<List<Account>> getAccounts(
      String clientID, String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.get(
        '$apiBaseURL/Client/GetAccounts?clientId=$clientID&includeQuote=true&includeOpen=true&includeClosed=true',
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'AuthFinWs token="${prefs.getString(PrefHelper.PREF_AUTH_TOKEN)}"'
        });
    print(clientID);
    print(response.body);
    for (Map m in jsonDecode(response.body))
      if (m['Status'] == 'Open')
        _accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Quote')
        _accounts.add(Account.fromJson(m));
      else if (m['Status'] == 'Closed') _accounts.add(Account.fromJson(m));
    notifyListeners();
    return _accounts;
  }

  List<Account> getAccountsList() {
    return [..._accounts];
  }
}
