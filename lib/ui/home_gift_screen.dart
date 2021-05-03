import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefinex/ui/home_link_screen.dart';
import 'package:wefinex/utils/uidata.dart';

class HomeGiftScreen extends StatefulWidget {
  @override
  _HomeGiftScreenState createState() => _HomeGiftScreenState();
}

class _HomeGiftScreenState extends State<HomeGiftScreen> {
  var url;
  var urlChPlay;
  final keyIsFirstLoaded = 'is_first_loaded';

  TextEditingController mobileNoController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isFirstLoaded;

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config.screenHome = true;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("WEFINEX"),
        backgroundColor: MyColors.deepSkyBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset("assets/images/ic_menu.png"),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      backgroundColor: MyColors.deepSkyBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                    width: double.infinity,
                    height: width / 5,
                    child: Image.asset(UIData.iconApp)),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeLinkScreen(
                                "https://wefinexxx.net/register")));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Image.asset(
                      'assets/images/button_sign up.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeLinkScreen("https://wefinexxx.net/login")));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Image.asset(
                      'assets/images/button_login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeLinkScreen(
                                      "https://www.muabannhanh.icu/")));
                        },
                        child: Container(
                            width: 55,
                            height: 55,
                            child: Image.asset('assets/images/ic_gift.png')),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeLinkScreen(
                                      "https://www.muabannhanh.icu/")));
                        },
                        child: Container(
                            width: 55,
                            height: 55,
                            child: Image.asset('assets/images/ic_zalo.png')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: MyColors.deepSkyBlue,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                // child: Container(
                //     width: double.infinity,
                //     height: 150,
                //     child: Image.asset(
                //       UIData.iconApp,
                //     )),
                decoration: BoxDecoration(
                  color: MyColors.warmBlue,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 70,
                        child: Image.asset(UIData.iconApp),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "WEFINEX",
                        style: TextStyle(color: MyColors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset("assets/images/ic_home.png")),
                title: Text(
                  'Trang chủ',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset("assets/images/ic_support.png")),
                title: Text(
                  'Hỗ trợ',
                  style: TextStyle(color: MyColors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeLinkScreen("https://www.muabannhanh.icu/")));
                },
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset("assets/images/ic_share.png")),
                title: Text(
                  'Chia sẻ ứng dụng',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _onShareWithEmptyOrigin(context);

                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset("assets/images/ic_rate.png")),
                title: Text(
                  'Đánh giá ứng dụng',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  _launchUniversalLinkIos(
                      "https://play.google.com/store/apps/details?id=binary.wefinex.tradebo&hl=vi&gl=US");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share(
        "https://play.google.com/store/apps/details?id=binary.wefinex.tradebo&hl=vi&gl=US");
  }
}
