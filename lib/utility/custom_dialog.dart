import 'package:flutter/material.dart';

class CustomDialog{

  static Future<void> showMyDialog(BuildContext context,String alertTitle,String alertMessage,String actionText,Function action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertMessage),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertTitle),
                Text(alertMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(actionText),
              onPressed:action,
            ),
          ],
        );
      },
    );
  }
}