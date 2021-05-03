import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewKuApp extends StatefulWidget {
  var linkUrl = "";
  bool isHome;

  WebviewKuApp(this.linkUrl, this.isHome);

  @override
  State<StatefulWidget> createState() => WebviewKuAppState();
}

class WebviewKuAppState extends State<WebviewKuApp> {
  final String removeHeader =
      "var elements = document.getElementsByClassName('mobile-header'); for(var i=0; i<elements.length; i++) { elements[i].remove();}";
  final String removeBGHeader =
      "var elements = document.getElementsByClassName('bg_header'); for(var i=0; i<elements.length; i++) { elements[i].remove();}";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript(removeHeader);
        // flutterWebviewPlugin.evalJavascript(removeBGHeader);
      }
    });
    return WebviewScaffold(
      url: widget.linkUrl,
      withZoom: true,
      withJavascript: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator()),
    );
  }
}
