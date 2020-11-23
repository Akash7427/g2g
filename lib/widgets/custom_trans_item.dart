import 'package:flutter/material.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/transactionModel.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
class CustomTransItem extends StatelessWidget {

   final Transaction transaction;
   final bool _isLarge;

  CustomTransItem(this.transaction,this._isLarge);
  @override
  Widget build(BuildContext context) {
      return Container(
      
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(DateFormat("dd MMM yy").format(transaction.date),
                      style: TextStyle(
                        fontSize: _isLarge ? 28 : 20,
                      )),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transaction.reference}',
              style: TextStyle(
                fontSize: _isLarge ? 28 : 20,
              ))
                    
                  ],
                ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
            '\$${transaction.balance.toStringAsFixed(2)}',
            style: TextStyle(
                  fontSize: _isLarge ? 28 : 20,
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
            endIndent:20,
            indent: 20,
          )
        ],
      ),

    );
  }
}