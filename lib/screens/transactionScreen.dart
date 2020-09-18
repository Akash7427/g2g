import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/transactionModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/widgets/custom_trans_item.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionsScreen extends StatefulWidget {
  final Account account;
  final List<Transaction> transactions;
  TransactionsScreen(this.account,this.transactions);
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _transactionScaffoldKey = GlobalKey<ScaffoldState>();
  
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        actions: [
        InkWell(
              onTap: () {
                launch("tel://1300197727");
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RawMaterialButton(
                    fillColor: Colors.blue[50],
                    child: Icon(Icons.call, color: kSecondaryColor, size: 30),
                    onPressed: () {
                      _transactionScaffoldKey.currentState.openDrawer();
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
                  )
                  )
              
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
      
        leading: RawMaterialButton(
          fillColor: Colors.blue[50],
          child: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _transactionScaffoldKey.currentState.openDrawer();
          },
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
      ),
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/bg.jpg'),fit: BoxFit.cover)
          ),
            child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: 
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                        buildHeader(),
                        buildListHeader(),
                        Expanded(
                                                  child: SingleChildScrollView(
                              child: Column(
                              children: [
                                for (Transaction transaction in widget.transactions)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:3.0),
                                  child: buildTransactionCard(transaction),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                    SizedBox(height:20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FlatButton(
                          color: kSecondaryColor,
                          onPressed: (){
                          Navigator.pop(context);
                        }, child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('BACK',
                              style: TextStyle(
                                  fontSize: _isLarge ? 25 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )),
                      ],
                    ),
                  ]),
                ),
              ),
           
      ),
          )),
    );
  }

  Container buildListHeader() {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text('DATE',
                    style: TextStyle(
                        fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 4,
                child: Text('REFERENCE',
                    style: TextStyle(
                        fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold)),
              ),
              Text('BALANCE',
                  style: TextStyle(
                      fontSize: _isLarge ? 14 : 12, fontWeight: FontWeight.bold))
            ,
             ],
          ),
          Divider(
          color: Colors.black54,
        )
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.account.accountID,
                style: TextStyle(
                    fontSize: _isLarge ? 25 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
              Text(
                " - Transactions",
                style: TextStyle(
                    fontSize: _isLarge ? 25 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(widget.account.accountTypeDescription,
                    style: TextStyle(
                        fontSize: _isLarge ? 30 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(width: 10),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: widget.account.status.toUpperCase() == 'OPEN'
                      ? kPrimaryColor
                      : (widget.account.status.toUpperCase() == 'QUOTE'
                          ? Colors.amber[300]
                          : Colors.red),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                    child: Text(widget.account.status.toUpperCase(),
                        style: TextStyle(
                            fontSize: _isLarge ? 16 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  )),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildTransactionCard(Transaction transaction) {
    return CustomTransItem(transaction, _isLarge);
  }
}
