import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/models/transactionModel.dart';
import 'package:g2g/response_models/transaction_response_model.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:g2g/models/transactionModel.dart';

class TransactionsController with ChangeNotifier{
  List<TransactionResponseModel> transactions = [];

  Future<List<TransactionResponseModel>> getTransactions(
      String accountID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('$apiBaseURL/Account/GetTransactions?accountId=$accountID');
    http.Response response = await http.get(
        '$apiBaseURL/Account/GetTransactions?accountId=$accountID',
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader:
          'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"'
        });
    transactions.clear();
    transactions = transactionResponseModelFromJson(
        response.body);

    //  print(jsonDecode(response.body));


    notifyListeners();
    return transactions;
  }

  List<TransactionResponseModel> get geTransactionList {
    return [...transactions];
  }

  int get listLength {
    return transactions.length;
  }
}
