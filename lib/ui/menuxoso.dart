import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefinex/ui/RSSDemo.dart';
import 'package:wefinex/ui/RSSDienToan.dart';
import 'package:wefinex/ui/RSSMienNam.dart';
import 'package:wefinex/ui/RSSMienTrung.dart';
import 'package:wefinex/ui/home_webview_screen.dart';
import 'package:wefinex/utils/uidata.dart';

class Menuxoso extends StatelessWidget {
  var services = [
    "Xổ Số Miền Bắc",
    "Xổ Số Miền Trung",
    "Xổ Số Miền Nam",
    "Xổ Số Điện Toán",
    "Sổ Mơ",
    "Quay Thử Xổ Số"
  ];
  var images = [
    "assets/images/iconlive.jpeg",
    "assets/images/iconlive.jpeg",
    "assets/images/iconlive.jpeg",
    "assets/images/iconlive.jpeg",
    "assets/images/iconmo.jpeg",
    "assets/images/iconquay.jpeg"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.7)),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        images[index],
                        height: 50,
                        width: 50,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            services[index],
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => RSSDemo(),
//                      ),
//                    );
//                  },

                  onTap: () => onTap(index, context)),
            );
          }),
    );
  }

  void onTap(int index, BuildContext context) async {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RSSDemo(),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RSSMienTrung(),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RSSMienNam(),
        ),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RSSDienToan(),
        ),
      );
    }
    if (index == 4) {
      // _launchInBrowser(Config.linkSoMo);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWebViewScreen(Config.linkSoMo),
        ),
      );
    }
    if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWebViewScreen(Config.linkQuayThu),
        ),
      );
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
