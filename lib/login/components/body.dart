import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wefinex/define/constants.dart';
import 'package:wefinex/login/components/background.dart';
import 'package:wefinex/login/components/rounded_button.dart';
import 'package:get/get.dart';
import 'package:wefinex/webview/web_view_page.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "welcome".tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "login".tr,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WebViewContainer("https://wefinex.net/login");
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "register".tr,
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WebViewContainer("https://wefinex.net/register?r=C3F6B97");
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
