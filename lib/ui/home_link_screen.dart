import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wefinex/utils/uidata.dart';
import 'package:wefinex/widget/webview.dart';

class HomeLinkScreen extends StatefulWidget {
  final String url;

  const HomeLinkScreen(this.url);
  @override
  _HomeLinkScreenState createState() => _HomeLinkScreenState();
}

class _HomeLinkScreenState extends State<HomeLinkScreen> {
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
    Config.screenHome = true;

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
