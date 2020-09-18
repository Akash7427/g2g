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
            margin: EdgeInsets.only(left:8.0,right:8.0,bottom:12.0,top:12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(DateFormat.yMMMd().format(transaction.transactionDate),
              style: TextStyle(
                fontSize: _isLarge ? 22 : 14,
              ))
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transaction.reference}',
              style: TextStyle(
                fontSize: _isLarge ? 22 : 14,
                fontWeight: FontWeight.w600,
              ))
                    
                  ],
                ),
                ),
                Text(
            '\$${transaction.balance.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: _isLarge ? 22 : 14,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor),
            textAlign: TextAlign.start,
          ),
              ],
            ),
          ),

         Divider(
          color: Colors.black54,
        )
        ],
      ),

    );
  }
}