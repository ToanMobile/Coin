import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wefinex/define/constants.dart';
import 'package:wefinex/languages/language.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.savePreferences, this.toggleTheme, this.darkEnabled, this.themeMode, this.switchOLED, this.darkOLED});

  final Function savePreferences;
  final Function toggleTheme;
  final bool darkEnabled;
  final int themeMode;
  final Function switchOLED;
  final bool darkOLED;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool enLanguage = false;

  toggleLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool language = prefs.getBool("language") ?? false;
    if (language) {
      LocalizationService().changeLocale(LocalizationService.langs.last);
    } else {
      LocalizationService().changeLocale(LocalizationService.langs.first);
    }
    enLanguage = !language;
    prefs.setBool("language", enLanguage);
  }

  _confirmDeletePortfolio() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("clear_portfolio".tr),
            content: Text("transactions_delete_all".tr),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await _deletePortfolio();
                    Navigator.of(context).pop();
                  },
                  child: Text("delete".tr)),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("cancel".tr))
            ],
          );
        });
  }

  Future<Null> _deletePortfolio() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/portfolio.json");
      jsonFile.delete();
      portfolioMap = {};
    });
  }

  _exportPortfolio() {
    String text = json.encode(portfolioMap);
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              titleSpacing: 0.0,
              elevation: appBarElevation,
              title: Text("export_portfolio".tr),
            ),
          ),
          body: SingleChildScrollView(
              child: InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              _scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Theme.of(context).indicatorColor, content: Text("copy_clipboard".tr)));
            },
            child: Container(padding: const EdgeInsets.all(10.0), child: Text(text, style: Theme.of(context).textTheme.bodyText2.apply(fontSizeFactor: 1.1))),
          )));
    }));
  }

  _showImportPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImportPage()));
  }

  _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String version = "";
  String buildNumber = "";

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    String theme = "automatic".tr;
    if (widget.themeMode == themeDark)
      theme = "dark".tr;
    else if (widget.themeMode == themeLight) {
      theme = "light".tr;
    } else {
      theme = "automatic".tr;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          titleSpacing: 0.0,
          elevation: appBarElevation,
          title: Text("setting".tr, style: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("preferences".tr, style: Theme.of(context).textTheme.bodyText1),
          ),
          Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () async {
                  toggleLanguage();
                },
                leading: Icon(enLanguage ? Icons.flag : Icons.flag_outlined),
                subtitle: Text(enLanguage ? "english".tr : "vietnam".tr),
                title: Text("language".tr),
              )),
          Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: widget.toggleTheme,
                leading: Icon(widget.darkEnabled ? Icons.brightness_3 : Icons.brightness_7),
                subtitle: Text(theme),
                title: Text("theme".tr),
              )),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.opacity),
              title: Text("oled_dark_mode".tr),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                value: widget.darkOLED,
                onChanged: (onOff) {
                  widget.switchOLED(state: onOff);
                },
              ),
              onTap: widget.switchOLED,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.short_text),
              title: Text("abbreviate_numbers".tr),
              trailing: Switch(
                  activeColor: Theme.of(context).accentColor,
                  value: shortenOn,
                  onChanged: (onOff) {
                    setState(() {
                      shortenOn = onOff;
                    });
                    widget.savePreferences();
                  }),
              onTap: () {
                setState(() {
                  shortenOn = !shortenOn;
                });
                widget.savePreferences();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("debug".tr, style: Theme.of(context).textTheme.bodyText1),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("export_portfolio".tr),
              leading: Icon(Icons.file_upload),
              onTap: _exportPortfolio,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("import_portfolio".tr),
              leading: Icon(Icons.file_download),
              onTap: _showImportPage,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("clear_portfolio_setting".tr),
              leading: Icon(Icons.delete),
              onTap: _confirmDeletePortfolio,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("issues_request".tr),
              leading: Icon(Icons.bug_report),
              onTap: () => _launchUrl("https://github.com/ToanMobile/Wefinex/issues"),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("${"version".tr} $version ($buildNumber)"),
              subtitle: Text("https://github.com/ToanMobile/Wefinex"),
              leading: Icon(Icons.info_outline),
              onTap: () => _launchUrl("https://github.com/ToanMobile/Wefinex"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("credit".tr, style: Theme.of(context).textTheme.bodyText1),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: RichText(
                  text: TextSpan(text: "maintained".tr, style: Theme.of(context).textTheme.subtitle1, children: <TextSpan>[
                TextSpan(text: "@ToanDev", style: Theme.of(context).textTheme.subtitle1.apply(color: Theme.of(context).buttonColor, fontWeightDelta: 2))
              ])),
              subtitle: Text("https://www.facebook.com/VanToanIT/"),
              leading: Icon(Icons.favorite),
              onTap: () => _launchUrl("https://www.facebook.com/VanToanIT/"),
            ),
          ),
        ],
      ),
    );
  }
}

class ImportPage extends StatefulWidget {
  @override
  ImportPageState createState() => ImportPageState();
}

class ImportPageState extends State<ImportPage> {
  TextEditingController _importController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> newPortfolioMap;
  Color textColor = Colors.red;
  List validSymbols = [];

  _checkImport(text) {
    try {
      Map<String, dynamic> checkMap = json.decode(text);
      if (checkMap.isEmpty) {
        throw "failed at empty map";
      }
      for (String symbol in checkMap.keys) {
        if (!validSymbols.contains(symbol)) {
          throw "symbol not valid";
        }
      }
      for (List transactions in checkMap.values) {
        if (transactions.isEmpty) {
          throw "failed at emtpy transaction list";
        }
        for (Map transaction in transactions) {
          if ((transaction.keys.toList()..sort()).toString() != ["exchange", "notes", "price_usd", "quantity", "time_epoch"].toString()) {
            throw "failed formatting check at transaction keys";
          }
          for (String K in transaction.keys) {
            if (K == "quantity" || K == "time_epoch" || K == "price_usd") {
              num.parse(transaction[K].toString());
            }
          }
        }
      }

      newPortfolioMap = checkMap;
      setState(() {
        textColor = Theme.of(context).textTheme.bodyText2.color;
      });
    } catch (e) {
      print("Invalid JSON: $e");
      newPortfolioMap = null;
      setState(() {
        textColor = Colors.red;
      });
    }
  }

  _importPortfolio() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${"import_portfolio".tr}?"),
            content: Text("overwrite_portfolio".tr),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    portfolioMap = newPortfolioMap;
                    await getApplicationDocumentsDirectory().then((Directory directory) {
                      File jsonFile = File(directory.path + "/portfolio.json");
                      jsonFile.writeAsStringSync(json.encode(portfolioMap));
                    });
                    Navigator.of(context).pop();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("success".tr)));
                  },
                  child: Text("import".tr)),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("cancel".tr))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    marketListData.forEach((coin) {
      validSymbols.add(coin["CoinInfo"]["Name"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(appBarHeight),
          child: AppBar(
            titleSpacing: 0.0,
            elevation: appBarElevation,
            title: Text("import_portfolio".tr),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 6.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      String clipText = (await Clipboard.getData('text/plain')).text;
                      _importController.text = clipText;
                      _checkImport(clipText);
                    },
                    child: Text("paste".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).iconTheme.color)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                  ),
                  ElevatedButton(
                      onPressed: textColor != Colors.red ? _importPortfolio : null,
                      child: Text("import".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).iconTheme.color)),
                      style: ElevatedButton.styleFrom(onPrimary: Colors.green)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _importController,
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyText2.apply(color: textColor, fontSizeFactor: 1.1),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
                      border: OutlineInputBorder(),
                      hintText: "enter_portfolio_json".tr),
                  onChanged: _checkImport,
                ),
              ),
            ],
          ),
        ));
  }
}
