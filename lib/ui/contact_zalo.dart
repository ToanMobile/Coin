import 'package:flutter/material.dart';
import 'package:wefinex/utils/uidata.dart';
import 'package:wefinex/widget/webview.dart';

class ContactZalo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.screenHome = false;

    return Scaffold(
      body: WebviewKuApp(Config.linkHome, true),
    );
  }
}
