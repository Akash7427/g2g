import 'package:flutter/material.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/controllers/file_doc_controller.dart';
import 'package:g2g/controllers/loanDocController.dart';

import 'package:g2g/models/loanDocModel.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CustomLoandocItem extends StatefulWidget {
  String accountId;
  LoanDocModel loanDocModel;
  final bool _isLarge;

  CustomLoandocItem(this.accountId, this.loanDocModel, this._isLarge);

  @override
  _CustomLoandocItemState createState() => _CustomLoandocItemState();
}

class _CustomLoandocItemState extends State<CustomLoandocItem> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var fileDocPro = Provider.of<FileDocController>(context, listen: false);
    return Column(
      children: [
        Container(
          margin:
              EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0, top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child:
                    Text(DateFormat.yMMMd().format(widget.loanDocModel.docDate),
                        style: TextStyle(
                          fontSize: widget._isLarge ? 16 : 14,
                        )),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.loanDocModel.docName,
                        style: TextStyle(
                          fontSize: widget._isLarge ? 18 : 14,
                        )),
                    Text(widget.loanDocModel.docFileName,
                        style: TextStyle(
                            fontSize: widget._isLarge ? 14 : 10,
                            color: kSecondaryColor))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      fileDocPro.fetchDoc(
                          widget.accountId,
                          widget.loanDocModel.getDocPk,
                          widget.loanDocModel.getDocFileName);
                    },
                    child: InkWell(
                      onTap: () {},
                      child: ImageIcon(
                        AssetImage("images/eye_icon.png"),
                        color: Color(0xFF3A5A98),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  InkWell(
                    onTap: () {},
                    child: ImageIcon(
                      AssetImage("images/download_icon.png"),
                      color: Color(0xFF3A5A98),
                    ),
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
    );
  }
}
