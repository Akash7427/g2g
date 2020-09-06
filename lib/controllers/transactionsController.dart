import 'dart:convert';
import 'dart:io';
import 'package:g2g/constants.dart';
import 'package:g2g/models/transactionModel.dart';
import 'package:http/http.dart' as http;
class TransactionsController{
    List<Transaction> transactions=[];
    Future<List<Transaction>> getTransactions(String accountID,String sessionToken)async{
      http.Response response=await http.get(
        '$apiBaseURL/Account/GetTransactions?accountId=$accountID',
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'AuthFinWs token="$sessionToken"'
        });
        print(jsonDecode(response.body));
        for (Map m in jsonDecode(response.body))
          transactions.add(Transaction.fromJson(m));
      return transactions;
    }
}