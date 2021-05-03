import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wefinex/utils/uidata.dart';
import 'package:wefinex/widget/webview.dart';

class HomeWebViewScreen extends StatefulWidget {
  final String url;

  HomeWebViewScreen(this.url);
  @override
  _HomeWebViewScreenState createState() => _HomeWebViewScreenState();
}

class _HomeWebViewScreenState extends State<HomeWebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  num position = 1;

  @override
  Widget build(BuildContext context) {
    Config.screenHome = false;

    return Scaffold(
      body: SafeArea(
          child: IndexedStack(index: position, children: <Widget>[
        WebView(
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (value) {
            setState(() {
              position = 1;
            });
          },
          onPageFinished: (value) {
            setState(() {
              position = 0;
            });
          },
        ),
        Container(
          child: Center(child: CircularProgressIndicator()),
        ),
      ])),
    );
  }
}
