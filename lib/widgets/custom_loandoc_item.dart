import 'package:flutter/material.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/controllers/file_doc_controller.dart';
import 'package:g2g/controllers/loanDocController.dart';

import 'package:g2g/models/loanDocModel.dart';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
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
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<FileDocController>(context, listen: false);
    final pr = ProgressDialog(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    onTap: () async {
                      await fProvider.viewFile( widget.loanDocModel.getDocFileName).then((value)async{
                        if(value != null){
                          await OpenFile.open(value.path);
                        }
                        else{
                          pr.show();

                          await fProvider
                              .fetchDoc(
                              widget.accountId,
                              widget.loanDocModel.getDocPk,
                              widget.loanDocModel.getDocFileName)
                              .then((value) async {
                            final result = await OpenFile.open(value.path);
                            print("outputOF${result.type}");
                            if (result.type != null) {
                              setState(() {
                                pr.hide();

                              });
                            }
                          });                        }
                      });
                     
                    },
                    child: ImageIcon(
                      AssetImage("images/eye_icon.png"),
                      color: Color(0xFF3A5A98),
                    ),
                  ),
                  // SizedBox(width: 12.0),
                  // InkWell(
                  //   onTap: () async {
                  //
                  //   },
                  //   child: ImageIcon(
                  //     AssetImage("images/download_icon.png"),
                  //     color: Color(0xFF3A5A98),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black54,
          endIndent:20,
          indent: 20,
        )
      ],
    );
  }

  Widget getFileDocWidget() {
    return FutureBuilder(
        future: Provider.of<FileDocController>(context, listen: false).fetchDoc(
            widget.accountId,
            widget.loanDocModel.getDocPk,
            widget.loanDocModel.getDocFileName),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              return Center(
                child: Text('Error occured'),
              );
            } else {
              return Consumer<FileDocController>(
                  builder: (ctx, fileDocC, widget) {
                OpenFile.open(fileDocC.getDocFile.path);
                return;
              });
            }
          }
        });
  }
}
