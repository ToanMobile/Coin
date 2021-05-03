import 'dart:ui';

import 'package:flutter/material.dart';

class AppSize {
  static final double leadingAppBarIcon = 28.0;

  //Avatar
  static final double avatarItemFriendSuggestionRadius = 25.0;
  static final double heightDivider = 3.0;

  // Button
  static final double loginButtonWidth = 500.0;
  static final double loginButtonHeight = 50.0;
  static final double followButtonWidth = 79.0;
  static final double followButtonHeight = 35.0;
  static final double unFollowButtonWidth = 87.0;
  static final double unFollowButtonHeight = 35.0;
  static final double iconComment = 25.0;
}

class Margin {
  static final double marginApp = 24.0;
  static final double margin10 = 10.0;
  static const double margin15 = 15.0;
  static final double margin20 = 20.0;
  static final double margin30 = 30.0;
  static final double margin50 = 50.0;
  static final double margin80 = 80.0;
}

class UIData {
  //images
  static const String imageDir = "assets";
  static const String iconApp = "$imageDir/icon/launcher_icon.png";

  //TABBAR
  static const String iconTabHome = "$imageDir/icons_home.png";
  static const String iconTabVoucher = "$imageDir/icons_discount.png";
  static const String iconTabsupport = "$imageDir/icons_headset.png";

  //Support
  static const String support1 = "$imageDir/support1.png";
  static const String support2 = "$imageDir/support2.png";
  static const String support3 = "$imageDir/support3.png";
  static const String support4 = "$imageDir/support4.png";
  static const String support5 = "$imageDir/support5.png";
  static const String support6 = "$imageDir/support6.png";
  static const String support7 = "$imageDir/support7.png";
  static const String supportHome = "$imageDir/support_home.png";
  static const String forget1 = "$imageDir/forget1.png";
  static const String forget2 = "$imageDir/forget2.png";
}

class MyColors {
  static const primaryGradientColor1 = Color(0xFF9c5aff);
  static const primaryGradientColor2 = Color(0xFFff7bab);
  static const colorPrimary = const Color(0xff01233F);
  static const slate = const Color(0xff4e586e);
  static const dark = const Color(0xff242a37);
  static const deepSkyBlue = const Color(0xff060642);
  static const black60 = const Color(0x99000000);
  static const blueGrey = const Color(0xff8e8e93);
  static const veryLightPink = const Color(0xfff3f3f3);
  static const white92 = const Color(0xebffffff);
  static const orangeRed = const Color(0xffff3b30);
  static const paleGrey = const Color(0xffefeff4);
  static const lightBlueGrey = const Color(0xffd1d1d6);
  static const warmBlue = const Color(0xff5856d6);
  static const black = const Color(0xff1d1d26);
  static const paleLilac = const Color(0xffe5e5ea);
  static const robinSEgg = const Color(0xff5ac8fa);
  static const weirdGreen = const Color(0xff4cd964);
  static const white = const Color(0xffffffff);
  static const tangerine = const Color(0xffff9500);
  static const marigold = const Color(0xffffcc00);
  static const black30 = const Color(0x4d000000);
  static const softBlue = const Color(0xff5aacff);
  static const redMedium = const Color(0xfff54b64);
  static const tanHide = const Color(0xFFF78361);
  static const grey100 = const Color(0xfff5f5f5);
  static const grey200 = const Color(0xffeeeeee);
  static const blur = const Color.fromARGB(75, 255, 255, 255);
  static const blurWhite = const Color.fromRGBO(255, 255, 255, 0.3);
  static const transparent = const Color.fromARGB(10, 255, 255, 255);
  static const darkGray = const Color(0xFF2A2E3A);
  static const blackRussian = const Color(0xFF20242F);
  static const text_login = const Color(0xffff2d55);
  static const redMedium_tanHide_gradient = const LinearGradient(
    colors: [
      MyColors.redMedium,
      MyColors.tanHide,
    ],
    begin: const Alignment(0.0, 1.0),
    end: const Alignment(1.0, 0.0),
  );
}

class StylesText {
  static const styleText50BoldWhite = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 50.0);
  static const headline1Left = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 40.0);
  static const headline1Center = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 40.0);
  static const largeTitle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 34.0);
  static const headline2Left = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 28.0);
  static const headline2Center = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 28.0);
  static const headline3RightBold = const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w700,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const headline3LeftBold = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const headline3CenterBold = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const headline3RightRegular = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const headline3LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const headline3LeftRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const headline3CenterRegular = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 22.0);
  static const body20RightBold = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body20LeftBold = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body20CenterBold = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body20LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body20CenterRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body20CenterRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const body17RightSemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17RightSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17LeftSemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17LeftSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterSemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const bodySemiBoldLeftBlack17pt = const TextStyle(
      color: const Color(0xff4a4a4a),
      fontWeight: FontWeight.w600,
      fontFamily: "SFUIText",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17RightRegularBlack = const TextStyle(
      color: const Color(0x66000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17RightRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17RightRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17LeftRegularGrey = const TextStyle(
      color: const Color(0x66ffffff),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17LeftRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterRegularBlack = const TextStyle(
      color: const Color(0x66000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const body17CenterRegularGrey = const TextStyle(
      color: const Color(0xff4e586e),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const bodyRegularLeftBlack17pt = const TextStyle(
      color: const Color(0xff262628),
      fontWeight: FontWeight.w400,
      fontFamily: "SFUIText",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);
  static const tagLine15SemiBoldNormal = const TextStyle(
      color: const Color(0xffff2d55),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const tagLine15SemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const tagLine15SemiBold = const TextStyle(
      color: const Color(0x67ffffff),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15RightSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15RightSemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15LeftSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15LeftSemiBoldWhite = const TextStyle(
      color: const Color(0xffffffff),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15CenterSemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15CenterSemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const bodyMediumLeftWhite15pt = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontFamily: "SFUIDisplay",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15RightRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15RightRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15RightRegularBlack = const TextStyle(
      color: const Color(0x66000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15LeftRegularSlate = const TextStyle(
      color: Colors.black,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 16.0);
  static const body15LeftRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15CenterRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const body15CenterRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const bodyRegularLeftGrey15 = const TextStyle(
      color: const Color(0xffc1c0c9),
      fontWeight: FontWeight.w400,
      fontFamily: "SFUIText",
      fontStyle: FontStyle.normal,
      fontSize: 15.0);
  static const blackDarkH400BodySemiBoldAlignLeft = const TextStyle(
      color: const Color(0xff0a1f44),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
  static const tagLine13SemiBold = const TextStyle(
      color: const Color(0x67ffffff),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const bodySemiBoldCenterBlack13pt = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w500,
      fontFamily: "SFUIText",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13RightRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13RightRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13RightRegularBlack = const TextStyle(
      color: const Color(0x66000000),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13LeftRegularDark = const TextStyle(
      color: const Color(0xff4e586e),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13LeftRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13CenterRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13CenterRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const caption13ptBlackReg = const TextStyle(
      color: const Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const bodyRegularRightGrey13pt = const TextStyle(
      color: const Color(0xffc1c0c9),
      fontWeight: FontWeight.w400,
      fontFamily: "SFUIText",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
  static const blackDisabledH200CaptionRegularAlignRight = const TextStyle(
      color: const Color(0xffa6aebc),
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 12.0);
  static const tagLine11SemiBold = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const tagLine11SemiBoldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const caption11RightRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const caption11RightRegularWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const caption11LeftRegular = const TextStyle(
      color: const Color(0xfff54b64),
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const caption11CenterRegular = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 11.0);
  static const activeText = const TextStyle(
      color: Color(0xfff54b64),
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);
  static const UnActiveText = const TextStyle(
      color: MyColors.slate,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);
}

class Config {
  //App Font
  //App Font
  static const String defaultFont = "Roboto";
  static const linkHome = 'https://wefinex.net/register?r=C3F6B97';
  static const linkMoney = 'https://muabannhanh.io/';

  static const linkTalkTo = 'https://zalo.me/g/cljpnl748';
  static const linkZalo = 'https://zalo.me/g/lnwkat018';
  static const linkData = 'https://wefinex.net/login';
  static const linkMienBac = 'https://lixi88.ltd/huongdan/';
  static const linkMienTrung = 'https://lixi88.ltd/huongdan/';
  static const linkMienNam = 'https://lixi88.ltd/huongdan/';
  static const linkDienToan = 'https://lixi88.ltd/huongdan/';
  static const linkSoMo = 'https://xskt.com.vn/so-mo/';
  static const linkQuayThu = 'https://xskt.com.vn/quay-thu-xo-so/index.html';

  static bool screenHome = true;
  static String linkUrl = '';
}
