import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:g2g/response_models/transaction_response_model.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../controllers/accountsController.dart';

class CustomTransItem extends StatelessWidget {
  final TransactionResponseModel transaction;
  final bool _isLarge;

  CustomTransItem(this.transaction, this._isLarge);

  @override
  Widget build(BuildContext context) {
    var accProvider = Provider.of<AccountsController>(context, listen: false);
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                      DateFormat("dd MMM yy")
                          .format(DateTime.parse(transaction.date)),
                      style: TextStyle()),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText('${transaction.reference}',
                          style: TextStyle(
                              // fontSize: _isLarge ? 28 : 20,
                              ))
                    ],
                  ),
                ),
                Expanded(
                  flex:2,
                  child: AutoSizeText(
                    '${accProvider.formatCurrency(transaction.balance)}',
                          // .toStringAsFixed(2)
                    style: TextStyle(
                        // fontSize: _isLarge ? 28 : 20,
                        ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.1,
            color: Colors.grey,
            endIndent: 20,
            indent: 20,
          )
        ],
      ),
    );
  }
}
