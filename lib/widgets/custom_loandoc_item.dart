import 'package:flutter/material.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
class CustomLoandocItem extends StatelessWidget {
  final Account account;
  final bool _isLarge;

  CustomLoandocItem(this.account,this._isLarge);
  


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
                  child: Text(DateFormat.yMMMd().format(account.openedDate),
                        style: TextStyle(
                          fontSize: _isLarge ? 16 : 14,
                        )),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Loan Contract',
                        style: TextStyle(
                          fontSize: _isLarge ? 18 : 14,
                        )),
                        Text('Loan_Contract_18054.pdf',style: TextStyle(
                          fontSize: _isLarge ? 14 : 10,
                          color: kSecondaryColor
                        ))
                    
                  ],
                ),
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImageIcon(
     AssetImage("images/eye_icon.png"),
     color: Color(0xFF3A5A98),
),
SizedBox(width:12.0),
                    ImageIcon(
     AssetImage("images/download_icon.png"),
     color: Color(0xFF3A5A98),
),
                  ],
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

  
