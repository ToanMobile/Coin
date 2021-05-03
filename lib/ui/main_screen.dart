//import 'package:wefinex/ui/home_screen.dart';
//import 'package:wefinex/ui/not_found_page.dart';
//import 'package:wefinex/ui/voucher_screen.dart';
//import 'package:wefinex/ui/home_rss_screen.dart';
//import 'package:wefinex/ui/contact_data.dart';
//import 'package:wefinex/ui/mainMenu.dart';
//
//import 'package:wefinex/utils/uidata.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//
//class DrawerItem {
//  String title;
//  IconData icon;
//
//  DrawerItem(this.title, this.icon);
//}
//
//class Main extends StatefulWidget {
//  final drawerItems = [
//    DrawerItem("Trang chủ", Icons.home),
//    DrawerItem("Bóng đá", Icons.stars),
//    DrawerItem("Hướng dẫn", Icons.face),
//    DrawerItem("Nhận khuyến mãi", Icons.monetization_on)
//  ];
//
//  @override
//  State<StatefulWidget> createState() {
//    return MainState();
//  }
//}
//
//class MainState extends State<Main> {
//  int _selectedDrawerIndex = 0;
//  _getDrawerItemWidget(int pos) {
//    switch (pos) {
//      case 0:
//        return Home();
//      case 1:
//        return mainMenu();
//      case 2:
//        return ContactMenu();
//      case 3:
//        return Voucher();
//      default:
//        return NotFoundPage();
//    }
//  }
//
//  void _onSelectItem(int index) {
//    setState(() => _selectedDrawerIndex = index);
//    Navigator.of(context).pop(); // close the drawer
//  }
//
////  @override
////  void initState() {
////    super.initState();
////    WidgetsBinding.instance.addPostFrameCallback((_) {
////      showDialog(
////        context: context,
////        builder: (cxt) => _showDialog(),
////      );
////    });
////  }
////
////  Widget _showDialog() {
////    return AlertDialog(
////      title: new Text('mo ap dau '),
////      content: new Text('hello'),
////      actions: <Widget>[
////        new FlatButton(
////          onPressed: () => Navigator.of(context).pop(false),
////          child: new Text('Không'),
////        ),
////        new FlatButton(
////          onPressed: () => Navigator.of(context).pop(true),
////          child: new Text('Có'),
////        ),
////      ],
////    );
////  }
//
////  bool checkTimeExit() {
////    DateTime currentDate = DateTime.now();
////    var dateExpire = DateTime.parse("2020-06-00 00:00:00Z");
////    if (currentDate.millisecondsSinceEpoch > dateExpire.millisecondsSinceEpoch) {
////      return true;
////    }
////    return false;
////  }
////
////  @override
////  void initState() {
////    super.initState();
////    print(checkTimeExit());
////    if (checkTimeExit()) {
////      exit(0);
////      SystemNavigator.pop();
////    }
////  }
//
//  Future<bool> _onWillPop(BuildContext context) {
//    print('Home_onWillPop==' + Navigator.canPop(context).toString());
//    print('Home_onWillPop111==' + Navigator.defaultRouteName);
//    if (Config.screenHome) {
//      return showDialog(
//            context: context,
//            builder: (context) => new AlertDialog(
//              title: new Text('Thoát ứng dụng?'),
//              content: new Text('Bạn muốn thoát App!'),
//              actions: <Widget>[
//                new FlatButton(
//                  onPressed: () => Navigator.of(context).pop(false),
//                  child: new Text('Không'),
//                ),
//                new FlatButton(
//                  onPressed: () => Navigator.of(context).pop(true),
//                  child: new Text('Có'),
//                ),
//              ],
//            ),
//          ) ??
//          false;
//    } else if (Config.linkUrl == Config.linkHomeSupport) {
//      return Future.value(false);
//    } else {
//      return Future.value(true);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    var drawerOptions = <Widget>[];
//    for (var i = 0; i < widget.drawerItems.length; i++) {
//      var d = widget.drawerItems[i];
//      drawerOptions.add(new ListTile(
//        leading: new Icon(
//          d.icon,
//          color: _selectedDrawerIndex == i ? Colors.red : Colors.blueGrey,
//          size: 40,
//        ),
//        title: new Text(
//          d.title,
//          style: TextStyle(
//              color: _selectedDrawerIndex == i ? Colors.red : Colors.blueGrey,
//              fontSize: 16),
//        ),
//
//        selected: i == _selectedDrawerIndex,
//        onTap: () => _onSelectItem(i),
//      ));
//    }
//    return Scaffold(
//      appBar: AppBar(
//        // here we display the title corresponding to the fragment
//        // you can instead choose to have a static title
//        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
//      ),
//      drawer: Drawer(
//        child: Column(
//          children: <Widget>[
//            Container(
//              color: Colors.white,
//              width: MediaQuery.of(context).size.width,
//              height: 150,
//              margin: EdgeInsets.only(top: 30),
//              child: Image.asset(
//                UIData.iconApp,
//                fit: BoxFit.fitWidth,
//              ),
//            ),
//            Column(children: drawerOptions)
//          ],
//        ),
//      ),
//      body: _getDrawerItemWidget(_selectedDrawerIndex),
//    );
//  }
//}
