import 'package:flutter/material.dart';
import 'package:wefinex/utils/uidata.dart';
import 'package:wefinex/widget/webview.dart';

class ContactData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.screenHome = false;
    return Scaffold(
      body: SafeArea(child: WebviewKuApp(Config.linkData, true)),
    );
  }
}
