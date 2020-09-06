import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/transactionsController.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/transactionModel.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/loanDocumentsScreen.dart';
import 'package:g2g/screens/loginScreen.dart';
import 'package:g2g/screens/transactionScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:after_layout/after_layout.dart';

class HomeScreen extends StatefulWidget {
  final Client client;
  final List<Account> accounts;
  HomeScreen(this.client, this.accounts);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen>{
  final _homeScreenScaffold = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  final transactionsController = TransactionsController();
  @override
  void afterFirstLayout(BuildContext context) {
    _showDialog();
  }
  bool isOverdue(){
    for(Account account in widget.accounts)
      if(account.balanceOverdue>0 && account.status=="Open")
        return true;
    return false;
  }
  bool isElligible(){
    for(Account account in widget.accounts)
      if((account.balanceOverdue>0 || account.balance>0) && account.status=="Open")
        return false;
    return true;
  }
  void _showDialog() {
    Alert(context: context, title: '', buttons: [
        DialogButton(
          color: isOverdue()?Colors.red[600]:
          (isElligible()?Colors.green:Colors.amberAccent),
          child: Text(
            "CLOSE",
            style: TextStyle(color: Colors.white, fontSize: _isLarge ? 24 : 18),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],content: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('${isOverdue()?'Hi':(isElligible()?'Welcome':'Well Done')}'+', ${widget.client.fullName.split(' ')[0]}',
              style: TextStyle(
                  fontSize: _isLarge ? 28 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
                  Text(isOverdue()?'Your Account is Overdue':(isElligible()?'You\'re elligible to reapply':'You\'re on Track'),
              style: TextStyle(
                  fontSize: _isLarge ? 24 : 18,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black)),
                  SizedBox(height: _isLarge ? 12 : 8,),
          Image.asset(isOverdue()?'images/overdue.png':(isElligible()?'images/reapply.png':'images/ontrack.png'),),
        ],
      ),
    ),style:AlertStyle(
     isCloseButton: false,
     isOverlayTapDismiss: false,
      titleStyle: TextStyle(fontSize:1)
    ) )
        .show();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);

    return Scaffold(
      key: _homeScreenScaffold,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                launch("tel://1300197727");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.call,
                  size: _isLarge ? 35 : 30,
                ),
              )),
              InkWell(
              onTap: () {
                Alert(
                    context: context,
                    title: 'Are you sure you want to Logout?',
                    style: AlertStyle(isCloseButton: false,titleStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                              fontSize: _isLarge ? 26 : 20)),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _isLarge ? 24 : 18),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: kSecondaryColor,
                        radius: BorderRadius.circular(10.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _isLarge ? 24 : 18),
                        ),
                        onPressed: (){
                           SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('isLoggedIn');
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()),
                      (r) => false);
                });
                        },
                        color: Colors.grey[600],
                        radius: BorderRadius.circular(10.0),
                      ),
                    ]).show();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.exit_to_app,
                  size: _isLarge ? 35 : 30,
                ),
              )),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSecondaryColor, size: 30),
        title: Text('Welcome, ${widget.client.fullName.split(' ')[0]}',
            style: TextStyle(
                fontSize: _isLarge ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: kSecondaryColor, size: 30),
          onPressed: () {
            _homeScreenScaffold.currentState.openDrawer();
          },
        ),
      ),
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
        child: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return buildPage(context, widget.accounts[index]);
          },
          itemCount: widget.accounts.length,
        ),
      )),
    );
  }

  SingleChildScrollView buildPage(BuildContext context, Account account) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              elevation: 10,
              shadowColor: kPrimaryColor,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      Card(
                          color: account.status.toUpperCase() == 'OPEN'
                              ? kPrimaryColor
                              : (account.status.toUpperCase() == 'QUOTE'
                                  ? Colors.amberAccent
                                  : Colors.red),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 14),
                            child: Text(account.status.toUpperCase(),
                                style: TextStyle(
                                    fontSize: _isLarge ? 25 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )),
                      SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.accountTypeDescription,
                            style: TextStyle(
                                fontSize: _isLarge ? 25 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Text(
                            account.accountID,
                            style: TextStyle(
                                fontSize: _isLarge ? 25 : 16,
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  !_isLarge
                      ? Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.16,
                              child: Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Next Repayment',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          '\$300',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: kSecondaryColor),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'By Direct Debit',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'July 14, 2020',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.notifications_active,
                                              size: 35)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${account.balanceOverdue == null ? 0.00 : account.balanceOverdue}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: account.balanceOverdue !=
                                                      null
                                                  ? (account.balanceOverdue > 0
                                                      ? Colors.red
                                                      : kPrimaryColor)
                                                  : kPrimaryColor),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          'Overdue',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.warning,
                                          color: account.balanceOverdue != null
                                              ? (account.balanceOverdue > 0
                                                  ? Colors.red
                                                  : kPrimaryColor)
                                              : kPrimaryColor,
                                        ),
                                        onPressed: () {})
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${account.balance}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          'Balance',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        icon:
                                            Icon(Icons.account_balance_wallet),
                                        onPressed: () {})
                                  ],
                                ),
                                SizedBox(height: 10),
                                FlatButton(
                                  onPressed: () {},
                                  color: kSecondaryColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('How to make a payment?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Card(
                                  color: Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Next Repayment',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            '\$300',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: kSecondaryColor),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Direct Debit',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        // fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    'July 14, 2020',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        // fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.notifications_active,
                                                  size: _isLarge ? 40 : 35)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$${account.balanceOverdue}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: kPrimaryColor),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              'Overdue',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.warning, size: 30),
                                            onPressed: () {})
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$${account.balance}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              'Balance',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(
                                                Icons.account_balance_wallet,
                                                size: 30),
                                            onPressed: () {})
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      color: kSecondaryColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('How to make a payment?',
                                            style: TextStyle(
                                                fontSize: _isLarge ? 25 : 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        )
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              shadowColor: kPrimaryColor,
              child: Padding(
                padding: EdgeInsets.all(_isLarge?15.0:0),
                child: Theme(
                  data:ThemeData(dividerColor: Colors.transparent,accentColor: kSecondaryColor),
                                child: ExpansionTile(
                    leading: Icon(
                      Icons.subject,
                      size: _isLarge ? 32 : 24,
                    ),
                    initiallyExpanded: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical:8.0),
                      child: Text(
                        'Loan Details',
                        style: TextStyle(
                          fontSize: _isLarge ? 28 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(_isLarge?20:10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLoanDetail(
                                    'Account Number', account.accountID),
                                SizedBox(height: _isLarge?30:15),
                                buildLoanDetail(
                                    'Maturity Date',
                                    account.openedDate.day.toString() +
                                        "/" +
                                        account.openedDate.month.toString() +
                                        "/" +
                                        account.openedDate.year.toString()),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLoanDetail(
                                    'Open Date',
                                    account.maturityDate.day.toString() +
                                        "/" +
                                        account.maturityDate.month.toString() +
                                        "/" +
                                        account.maturityDate.year.toString()),
                                SizedBox(height:_isLarge?30: 15),
                                buildLoanDetail('Payments Remaining', '20'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              shadowColor: kPrimaryColor,
              child: Padding(
                padding: EdgeInsets.all(_isLarge?15.0:0),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoanDocuments(account)));
                    },
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: _isLarge ? 32 : 24,
                    ),
                    leading: Icon(
                      Icons.folder,
                      size: _isLarge ? 32 : 24,
                    ),
                    title: Text('Loan Documents',
                        style: TextStyle(
                          fontSize: _isLarge ? 28 : 20,
                          fontWeight: FontWeight.w600,
                        ))),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              shadowColor: kPrimaryColor,
              child: Padding(
                padding:  EdgeInsets.all(_isLarge?15.0:0),
                child: ListTile(
                  onTap: () async {
                    final pr = ProgressDialog(context);
                    pr.show();
                    transactionsController
                        .getTransactions(
                            account.accountID, widget.client.sessionToken)
                        .then((transactions) {
                      pr.hide();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TransactionsScreen(account, transactions)));
                    });
                  },
                  leading: Icon(
                    Icons.payment,
                    size: _isLarge ? 32 : 24,
                  ),
                  title: Text('Transactions',
                      style: TextStyle(
                        fontSize: _isLarge ? 28 : 20,
                        fontWeight: FontWeight.w600,
                      )),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: _isLarge ? 32 : 24,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column buildLoanDetail(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data,
          style: TextStyle(
              fontSize: _isLarge ? 22 : 15,
              fontWeight: FontWeight.w600,
              color: kSecondaryColor),
          textAlign: TextAlign.start,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: _isLarge ? 22 : 15,
              // fontWeight: FontWeight.w600,
              color: Colors.black54),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
