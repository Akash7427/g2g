import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:g2g/components/navigationDrawer.dart';
import 'package:g2g/constants.dart';
import 'package:g2g/controllers/loanDocController.dart';
import 'package:g2g/models/accountModel.dart';

import 'package:g2g/responsive_ui.dart';
import 'package:g2g/screens/twakToScreen.dart';

import 'package:g2g/widgets/custom_loandoc_item.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:url_launcher/url_launcher.dart';

import 'homeScreen.dart';

class LoanDocuments extends StatefulWidget {
  final Account account;
  LoanDocuments(this.account);
  @override
  _LoanDocumentsState createState() => _LoanDocumentsState();
}

class _LoanDocumentsState extends State<LoanDocuments> {
  final _documentScaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch

    // if failed,use refreshFailed()
    if(mounted)
      setState(() {

      });

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);



    return Scaffold(
      drawer: NavigationDrawer(),
      key: _documentScaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // this will be set when a new tab is tapped
        onTap: (value) => setState(() {
          switch (value) {
            case 0:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                      settings: RouteSettings(
                        arguments: 0,
                      )));
              break;// Create this function, it should return your first page as a widget
            case 1:
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ApplyNowScreen()),
            //         (r) => r.isFirst);
              launch('https://www.goodtogoloans.com.au/');
              break;// Create this function, it should return your second page as a widget
            case 2:
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TawkToScreen()),
                      (r) => r.isFirst);
              break;// Create this function, it should return your third page as a widget
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
                    fontWeight: FontWeight.bold),
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
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/connect.png'),
                  size: _isLarge ? 38 : 25, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Connect',
                style: TextStyle(
                    fontSize: _isLarge ? 22 : 18,
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold),
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
        child: Stack(

          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: const AssetImage('images/bg.jpg'),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: AppBar(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xffccebf2),
                  child: IconButton(
                    onPressed: () {
                      _documentScaffoldKey.currentState.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: kSecondaryColor,
                      size: _isLarge ? 35 : 30,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(),
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
              top: 100.0,
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              //here the body
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Column(
                      children: [
                        buildHeader(),
                        SizedBox(height: 8,),
                        buildListHeader(),
                        Expanded(
                                              child: FutureBuilder(
                            future:
                                Provider.of<LoanDocController>(context, listen: false)
                                    .fetchLoanDocList(widget.account.accountID),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SpinKitThreeBounce(color: Theme.of(context).accentColor,size: _width*0.14,),
                                );
                              } else {
                                if (snapshot.error != null) {
                                  return Center(
                                    child: Text('No Documents Found'),
                                  );
                                } else {
                                  return Consumer<LoanDocController>(
                                      builder: (ctx, docData, _) =>
                                          MediaQuery.removePadding(
                                            context: ctx,
                                            removeTop: true,
                                            child: ListView.builder(
                                              itemBuilder: (ctx, index) {
                                                return CustomLoandocItem(
                                                  widget.account.accountID,
                                                    docData.getLoanDocList[index],
                                                    _isLarge);
                                              },
                                              itemCount:
                                                  docData.getLoanDocList.length,
                                            ),
                                          )
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  color: kSecondaryColor,

                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.arrow_back,color:Colors.white),
                                        SizedBox(width: 4,),
                                        Text('BACK',

                                            style: TextStyle(
                                                fontSize: _isLarge ? 25 : 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          textAlign: TextAlign.center
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildListHeader() {
    return Container(

      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text('DATE',
                      style: TextStyle(
                          fontSize: _isLarge ? 14 : 12,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 4,
                  child: Text('NAME',
                      style: TextStyle(
                          fontSize: _isLarge ? 14 : 12,
                          fontWeight: FontWeight.bold)),
                ),
                Text('ACTIONS',
                    style: TextStyle(
                        fontSize: _isLarge ? 14 : 12,
                        fontWeight: FontWeight.bold)),
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
                " - Loan Documents",
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
}
