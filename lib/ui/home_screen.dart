import 'package:flutter/material.dart';
import 'package:wefinex/ui/HomeScreen.dart';
import 'package:wefinex/ui/home_gift_screen.dart';
import 'package:wefinex/ui/not_found_page.dart';
import 'package:wefinex/utils/uidata.dart';

import 'menuxoso.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  int _selectedBottomIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }

  _getBottomItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomeGiftScreen();
      case 1:
        return Menuxoso();
      case 2:
        return HomeScreen();

      default:
        return NotFoundPage();
    }
  }

  Future<bool> _onWillPop(BuildContext context) {
    print('Home_onWillPop==' + Navigator.canPop(context).toString());
    print('Home_onWillPop111==' + Navigator.defaultRouteName);
    if (Config.screenHome) {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Thoát ứng dụng?'),
              content: new Text('Bạn muốn thoát App!'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Không'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Có'),
                ),
              ],
            ),
          ) ??
          false;
    } else if (Config.linkUrl == Config.linkData) {
      _onItemTapped(0);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop(context);
      },
      child: Scaffold(
        body: _getBottomItemWidget(_selectedBottomIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
//              icon: Image.asset(UIData.iconTabHome),
                icon: Icon(Icons.home),
                title: Text('Trang chủ'),
                backgroundColor: MyColors.redMedium),
            BottomNavigationBarItem(
//              icon: Image.asset(UIData.iconTabVoucher),
                icon: Icon(Icons.spa),
                title: Text('Xổ số'),
                backgroundColor: MyColors.redMedium),
            BottomNavigationBarItem(
//              icon: Image.asset(UIData.iconTabVoucher),
                icon: Icon(Icons.stars),
                title: Text('Bóng đá'),
                backgroundColor: MyColors.redMedium),
          ],
          iconSize: 30,
          currentIndex: _selectedBottomIndex,
//          unselectedIconTheme: IconThemeData(color: Colors.blueAccent, opacity: 1.0, size: 30.0),
          selectedItemColor: MyColors.redMedium,
          unselectedItemColor: Colors.blueGrey,

          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
