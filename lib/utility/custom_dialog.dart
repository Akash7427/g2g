import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDialog{

  static Future<void> showMyDialog(BuildContext context,String alertTitle,String alertMessage,String actionText,Function action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText(alertMessage),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                AutoSizeText(alertTitle),
                AutoSizeText(alertMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: AutoSizeText('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: AutoSizeText(actionText),
              onPressed:action,
            ),
          ],
        );
      },
    );
  }
}