import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../responsive_ui.dart';

class customAppBar extends StatefulWidget {
  String name;
  GlobalKey<ScaffoldState> key = GlobalKey(); // add this
  customAppBar({@required key, @required name, @required child});

  @override
  _customAppBarState createState() => _customAppBarState();
}

class _customAppBarState extends State<customAppBar> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _isLarge;

  Widget child;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _width = MediaQuery.of(context).size.width;
    _isLarge = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    return Scaffold(
      key: widget.key,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // this will be set when a new tab is tapped
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: ImageIcon(AssetImage('images/loan.png'),
                  size: _isLarge ? 28 : 24, color: kSecondaryColor),
            ),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: AutoSizeText(
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
              child: AutoSizeText(
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
              child: AutoSizeText(
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
      body: Stack(
        children: [
          Container(
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
                        widget.key.currentState.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: kSecondaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  AutoSizeText('Hi ${widget.name}',
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
          new Positioned(child: Container(child: child)),
        ],
      ),
    );
  }
}
