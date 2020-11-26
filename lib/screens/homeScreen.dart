import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/components/progressDialog.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/accountsController.dart';
import 'package:g2g/controllers/clientController.dart';
import 'package:g2g/controllers/transactionsController.dart';
import 'package:g2g/models/accountModel.dart';
import 'package:g2g/models/clientModel.dart';
import 'package:g2g/responsive_ui.dart';
import 'package:g2g/utility/pref_helper.dart';

import 'package:g2g/screens/apply_now.dart';
import 'package:g2g/screens/loanDocumentsScreen.dart';
import 'package:g2g/screens/transactionScreen.dart';
import 'package:g2g/screens/twakToScreen.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  final _homeScreenScaffold = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  final transactionsController = TransactionsController();
  List<Account> accounts;

  int bottomNavIndex = 0;
  Client client;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  var accProvider;

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    accounts = accProvider.getAccountsList();
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }


  @override
  void afterFirstLayout(BuildContext context) {
  int  flag =  ModalRoute.of(context).settings.arguments;
  print('navFlag'+ flag.toString());
  if(flag==1)
        _showDialog();


  }

  bool isOverdue() {
    try {
      for (Account account in accounts) {
        if ((account.balanceOverdue??0.0) > 0.0 && account.status == "Open")
          return true;
      }
    }catch(error){
      print(error.toString());
    }
    return false;
  }

  bool isElligible() {
    for (Account account in accounts)
      if (((account.balanceOverdue??0.0) > 0.0 || account.balance > 0) &&
          account.status == "Open") return false;
    return true;
  }

  payURL() async {
    await ClientController().getClientBasic();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var name = accounts[0].Name;
    List fname = name.split(',');
    print('fname' + fname[1]);

    try {
      String url =
          'https://www.goodtogoloans.com.au/payments/?fname=${fname[1].toString().trim()}&lname=${fname[0]}&email=${prefs.getString(PrefHelper.PREF_EMAIL_ID)}&account_id=${prefs.getString(PrefHelper.PREF_ACCOUNT_ID)}&client_id=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&amount=${accounts[0].balance}';
      print(url);
      await launch(url);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _showDialog() {
    Alert(
            context: context,
            title: '',
            buttons: [
              DialogButton(
                color: isOverdue()
                    ? Colors.red[600]
                    : (isElligible() ? Colors.green : Colors.amberAccent),
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                      color: Colors.white, fontSize: _isLarge ? 24 : 18),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                      '${isOverdue() ? 'Hi' : (isElligible() ? 'Welcome' : 'Well Done')}' +
                          ', ${client.fullName.split(' ')[0]}',
                      style: TextStyle(
                          fontSize: _isLarge ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      isOverdue()
                          ? 'Your Account is Overdue'
                          : (isElligible()
                              ? 'You\'re eligible to reapply'
                              : 'You\'re on Track'),
                      style: TextStyle(
                          fontSize: _isLarge ? 24 : 18,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(
                    height: _isLarge ? 12 : 8,
                  ),
                  Image.asset(
                    isOverdue()
                        ? 'images/overdue.png'
                        : (isElligible()
                            ? 'images/reapply.png'
                            : 'images/ontrack.png'),
                  ),
                ],
              ),
            ),
            style: AlertStyle(
                isCloseButton: false,
                isOverlayTapDismiss: false,
                titleStyle: TextStyle(fontSize: 1)))
        .show();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);

    accProvider = Provider.of<AccountsController>(context, listen: false);
    var clientProvider = Provider.of<ClientController>(context, listen: false);


    client = clientProvider.getClient();
    accounts = accProvider.getAccountsList();



    return Scaffold(
      key: _homeScreenScaffold,
      drawer: NavigationDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // this will be set when a new tab is tapped
        onTap: (value) =>
            setState(() {
              switch (value) {
                case 0:
                  break; // Create this function, it should return your first page as a widget
                case 1:
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ApplyNowScreen()),
                //         (r) => r.isFirst);
                  launch('https://www.goodtogoloans.com.au/');
                  break; // Create this function, it should return your second page as a widget
                case 2:
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => TawkToScreen()),
                          (r) => r.isFirst);
                  break; // Create this function, it should return your third page as a widget
              // Create this function, it should return your fourth page as a widget
              }
            }),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/loan.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'My Loans',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/apply_now.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/connect.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Connect',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: new Stack(
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: const AssetImage('images/bg.jpg'),
                      fit: BoxFit.cover)),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                child: AppBar(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffccebf2),
                    child: IconButton(
                      onPressed: () {
                        _homeScreenScaffold.currentState.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: kSecondaryColor,
                        size: _isLarge ? 35 : 30,
                      ),
                    ),
                  ),
                  title: Text('Hi ${(client.fullName.split(' ')[0])}',
                      //widget.client.fullName.split(' ')[0]
                      style: TextStyle(
                          fontSize: _isLarge ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xffccebf2),
                      child: IconButton(
                        onPressed: () {
                          launch("tel://1300197727");
                        },
                        icon: Icon(
                          Icons.call,
                          color: kSecondaryColor,
                          size: _isLarge ? 35 : 30,
                        ),
                      ),
                    ),
                  ],
                )
                // AppBar(
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       CircleAvatar(
                //         radius: 25,
                //         backgroundColor: Color(0xffccebf2),
                //         child: IconButton(
                //           onPressed: () {
                //             _homeScreenScaffold.currentState.openDrawer();
                //           },
                //           icon: Icon(
                //             Icons.menu,
                //             color: kSecondaryColor,
                //             size: 30,
                //           ),
                //         ),
                //       ),
                //       Text('Hi ${widget.client.fullName.split(' ')[0]}',
                //           //widget.client.fullName.split(' ')[0]
                //           style: TextStyle(
                //               fontSize: _isLarge ? 28 : 22,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black)),
                //       CircleAvatar(
                //         radius: 25,
                //         backgroundColor: Color(0xffccebf2),
                //         child: IconButton(
                //           onPressed: () {
                //             launch("tel://1300197727");
                //           },
                //           icon: Icon(
                //             Icons.call,
                //             color: kSecondaryColor,
                //             size: _isLarge ? 35 : 30,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   backgroundColor: Colors.transparent,
                //   elevation: 0.0,
                // ),
                ),
            new Positioned(
              top: MediaQuery.of(context).size.height*0.1,
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              //here the body
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildPage(context, accounts[index]);
                },
                itemCount: accounts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setUserForm() {
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:
        bottomNavIndex, // this will be set when a new tab is tapped
        onTap: (value) => setState(() => bottomNavIndex = value),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/loan.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'My Loans',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/apply_now.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/connect.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Connect',
                style: TextStyle(
                  fontSize: _isLarge ? 22 : 18,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('images/bg.jpg'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffccebf2),
                    child: IconButton(
                      onPressed: () {
                        _homeScreenScaffold.currentState.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: kSecondaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  Text('Hi ${client.fullName.split(' ')[0]}',
                      //widget.client.fullName.split(' ')[0]
                      style: TextStyle(
                          fontSize: _isLarge ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffccebf2),
                    child: IconButton(
                      onPressed: () {
                        launch("tel://1300197727");
                      },
                      icon: Icon(
                        Icons.call,
                        color: kSecondaryColor,
                        size: _isLarge ? 35 : 30,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          new Positioned(
              top: 110.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0,
            //here the body
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return buildPage(context, accounts[index]);
              },
              itemCount: accounts.length,
            ),
          ),
        ],
      ),
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
            padding: EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      // Card(
                      //     color: account.status.toUpperCase() == 'OPEN'
                      //         ? kPrimaryColor
                      //         : (account.status.toUpperCase() == 'QUOTE'
                      //             ? Colors.amberAccent
                      //             : Colors.red),
                      // Text(account.status.toUpperCase(),
                      //     style: TextStyle(
                      //         fontSize: _isLarge ? 25 : 16,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white)),
                      // SizedBox(width: 6),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.accountID,
                                style: TextStyle(
                                    fontSize: _isLarge ? 25 : 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 10),
                              Text(
                                account.accountTypeDescription,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: _isLarge ? 50 : 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  !_isLarge
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Overdue',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black45),
                                        textAlign: TextAlign.start,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${account.balanceOverdue == null ? 0.00 : account.balanceOverdue}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: account.balanceOverdue !=
                                                        null
                                                    ? (account.balanceOverdue >
                                                            0
                                                        ? Colors.red
                                                        : kPrimaryColor)
                                                    : kSecondaryColor),
                                            textAlign: TextAlign.start,
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.info_outline,
                                                color: account.balanceOverdue !=
                                                        null
                                                    ? (account.balanceOverdue >
                                                            0
                                                        ? Colors.red
                                                        : kPrimaryColor)
                                                    : kSecondaryColor,
                                              ),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(
                                    color: Colors.black54,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Balance',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black45),
                                        textAlign: TextAlign.start,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${account.balance}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                  Icons.account_balance_wallet),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text('How to make a payment? ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: kSecondaryColor)),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: kSecondaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FlatButton(
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      payURL();
                                    },
                                    child: Text(
                                      'Pay ' +
                                          '\$' +
                                          '${account.balance.toString()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            /*Expanded(
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
                            ),*/
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
                                                  color: Colors.black45
                                                  ),
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
                                                  color: Colors.black45),
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
/*
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              color: kWhiteColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Next Repayment',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            '\$300.00',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Text(
                          'By Direct Debit, July 14, 2020',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'OpenSans'),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 40,
                            color: kSecondaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Remind Me',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
*/
          SizedBox(
            width: 10,
          ),
          //Expansion Tiles
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isLarge ? 15.0 : 20,
                    ),
                    child: Theme(
                      data: ThemeData(
                          dividerColor: Colors.transparent,
                          accentColor: Colors.black),
                      child: ExpansionTile(
                        leading: ImageIcon(AssetImage('images/loan.png'),
                            size: _isLarge ? 32 : 24, color: kSecondaryColor),
                        initiallyExpanded: true,
                        title: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Loan Details',
                            style: TextStyle(
                              fontSize: _isLarge ? 28 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(_isLarge ? 20 : 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildLoanDetail(
                                        'Account Number', account.accountID),
                                    SizedBox(height: _isLarge ? 30 : 15),
                                    buildLoanDetail(
                                        'Maturity Date',
                                        account.openedDate.day.toString() +
                                            "/" +
                                            account.openedDate.month
                                                .toString() +
                                            "/" +
                                            account.openedDate.year.toString()),
                                  ],
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    buildLoanDetail(
                                        'Open Date',
                                        account.maturityDate.day.toString() +
                                            "/" +
                                            account.maturityDate.month
                                                .toString() +
                                            "/" +
                                            account.maturityDate.year
                                                .toString()),
                                    //SizedBox(height: _isLarge ? 30 : 15),
                                    // buildLoanDetail('Payments Remaining', '20'),
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
              Divider(color: Colors.grey,height: 1,indent: 16,endIndent: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  color:Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isLarge ? 15.0 : 20,
                    ),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoanDocuments(account)));
                        },
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          size: _isLarge ? 32 : 24,
                        ),
                        leading: ImageIcon(AssetImage('images/documents.png'),
                            size: _isLarge ? 32 : 24, color: kSecondaryColor),
                        title: Text('Loan Documents',
                            style: TextStyle(
                              fontSize: _isLarge ? 28 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ))),
                  ),
                ),
              ),
              Divider(color: Colors.grey,height: 1,indent: 16,endIndent: 16,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isLarge ? 15.0 : 20,
                    ),
                    child: ListTile(
                      onTap: () async {
                        print(account.balance.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionsScreen(
                                        account)));
                      },
                      leading: ImageIcon(
                        AssetImage('images/transaction.png'),
                        size: _isLarge ? 32 : 24,
                        color: kSecondaryColor,
                      ),
                      title: Text('Transactions',
                          style: TextStyle(
                            fontSize: _isLarge ? 28 : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: _isLarge ? 32 : 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
