import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:wefinex/define/constants.dart';
import 'package:wefinex/login/login_screen.dart';
import 'main.dart';
import 'trace/market_coin_item.dart';
import 'portfolio/portfolio_tabs.dart';
import 'portfolio/transaction_sheet.dart';
import 'trace/portfolio_item.dart';

class Tabs extends StatefulWidget {
  Tabs({this.toggleTheme, this.savePreferences, this.handleUpdate, this.darkEnabled, this.themeMode, this.switchOLED, this.darkOLED});

  final Function toggleTheme;
  final Function handleUpdate;
  final Function savePreferences;

  final bool darkEnabled;
  final int themeMode;

  final Function switchOLED;
  final bool darkOLED;

  @override
  TabsState createState() => TabsState();
}

class TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _textController = TextEditingController();
  int _tabIndex = 0;

  bool isSearching = false;
  String filter;

  bool sheetOpen = false;

  _handleFilter(value) {
    if (value == null) {
      isSearching = false;
      filter = null;
    } else {
      filter = value;
      isSearching = true;
    }
    _filterMarketData();
    setState(() {});
  }

  _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  _stopSearch() {
    setState(() {
      isSearching = false;
      filter = null;
      _textController.clear();
      _filterMarketData();
    });
  }

  _handleTabChange() {
    _tabIndex = _tabController.animation.value.round();
    if (isSearching) {
      _stopSearch();
    } else {
      setState(() {});
    }
  }

  _openTransaction() {
    setState(() {
      sheetOpen = true;
    });
    _scaffoldKey.currentState
        .showBottomSheet((BuildContext context) {
          return TransactionSheet(
            () {
              setState(() {
                _makePortfolioDisplay();
              });
            },
            marketListData,
          );
        })
        .closed
        .whenComplete(() {
          setState(() {
            sheetOpen = false;
          });
        });
  }

  _makePortfolioDisplay() {
    print("making portfolio display");
    Map portfolioTotals = {};
    List neededPriceSymbols = [];

    portfolioMap.forEach((coin, transactions) {
      num quantityTotal = 0;
      transactions.forEach((value) {
        quantityTotal += value["quantity"];
      });
      portfolioTotals[coin] = quantityTotal;
      neededPriceSymbols.add(coin);
    });

    portfolioDisplay = [];
    num totalPortfolioValue = 0;
    marketListData.forEach((coin) {
      String symbol = coin["CoinInfo"]["Name"];
      if (neededPriceSymbols.contains(symbol) && portfolioTotals[symbol] != 0) {
        portfolioDisplay.add({
          "symbol": symbol,
          "price_usd": coin["RAW"]["USD"]["PRICE"],
          "percent_change_24h": coin["RAW"]["USD"]["CHANGEPCT24HOUR"],
          "percent_change_1h": coin["RAW"]["USD"]["CHANGEPCTHOUR"],
          "total_quantity": portfolioTotals[symbol],
          "id": coin["CoinInfo"]["Id"],
          "name": coin["CoinInfo"]["FullName"],
          "CoinInfo": coin["CoinInfo"]
        });
        totalPortfolioValue += (portfolioTotals[symbol] * coin["RAW"]["USD"]["PRICE"]);
      }
    });

    num total24hChange = 0;
    num total1hChange = 0;
    portfolioDisplay.forEach((coin) {
      total24hChange += (coin["percent_change_24h"] * ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
      total1hChange += (coin["percent_change_1h"] * ((coin["price_usd"] * coin["total_quantity"]) / totalPortfolioValue));
    });

    totalPortfolioStats = {"value_usd": totalPortfolioValue, "percent_change_24h": total24hChange, "percent_change_1h": total1hChange};

    _sortPortfolioDisplay();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation.addListener(() {
      if (_tabController.animation.value.round() != _tabIndex) {
        _handleTabChange();
      }
    });

    _makePortfolioDisplay();
    _filterMarketData();
    _refreshMarketPage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        drawer: Drawer(
            child: Scaffold(
                bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Theme.of(context).bottomAppBarColor),
                    )),
                    child: ListTile(
                      onTap: widget.toggleTheme,
                      leading: Icon(widget.darkEnabled ? Icons.brightness_3 : Icons.brightness_7, color: Theme.of(context).buttonColor),
                      title: Text(theme, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).buttonColor)),
                    )),
                body: ListView(
                  children: <Widget>[
                    //TODO
                    /*ListTile(
                      leading: Icon(Icons.home_rounded),
                      title: Text("login".tr),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                    ),*/
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("setting".tr),
                      onTap: () => Navigator.pushNamed(context, "/settings"),
                    ),
                    ListTile(
                      leading: Icon(Icons.timeline),
                      title: Text("portfolio_timeline".tr),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioTabs(0, _makePortfolioDisplay))),
                    ),
                    ListTile(
                      leading: Icon(Icons.pie_chart_outlined),
                      title: Text("portfolio_breakdown".tr),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioTabs(1, _makePortfolioDisplay))),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).bottomAppBarColor, width: 1.0))),
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                    ),
                    ListTile(
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
                    ListTile(
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
                  ],
                ))),
        floatingActionButton: _tabIndex == 0 ? _transactionFAB(context) : null,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: [
                  Text("portfolio".tr),
                  isSearching
                      ? TextField(
                          controller: _textController,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.subhead,
                          onChanged: (value) => _handleFilter(value),
                          autofocus: true,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration.collapsed(hintText: 'search_name_symbols'.tr),
                        )
                      : GestureDetector(
                          onTap: () => _startSearch(),
                          child: Text("aggregate_markets".tr),
                        ),
                ][_tabIndex],
                actions: <Widget>[
                  [
                    Container(),
                    isSearching
                        ? IconButton(icon: Icon(Icons.close), onPressed: () => _stopSearch())
                        : IconButton(icon: Icon(Icons.search, color: Theme.of(context).primaryIconTheme.color), onPressed: () => _startSearch()),
                    Container()
                  ][_tabIndex],
                ],
                pinned: true,
                floating: true,
                titleSpacing: 3.0,
                elevation: appBarElevation,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(38.0),
                    child: Container(
                      height: 38.0,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).accentIconTheme.color,
                        unselectedLabelColor: Theme.of(context).disabledColor,
                        labelColor: Theme.of(context).accentIconTheme.color,
                        tabs: <Tab>[
                          Tab(icon: Icon(Icons.person)),
                          Tab(icon: Icon(Icons.filter_list)),
                        ],
                      ),
                    )),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [portfolioPage(context), marketPage(context)],
          ),
        ));
  }

  Widget _transactionFAB(BuildContext context) {
    return sheetOpen
        ? FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.close),
            foregroundColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).accentIconTheme.color,
            elevation: 4.0,
            tooltip: "close_transaction".tr,
          )
        : FloatingActionButton.extended(
            onPressed: _openTransaction,
            icon: Icon(Icons.add),
            label: Text("add_transaction".tr),
            foregroundColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).accentIconTheme.color,
            elevation: 4.0,
            tooltip: "add_transaction".tr,
          );
  }

  final portfolioColumnProps = [.25, .35, .3];

  Future<Null> _refreshPortfolioPage() async {
    await getMarketData();
    getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  List portfolioSortType = ["holdings", true];
  List sortedPortfolioDisplay;

  _sortPortfolioDisplay() {
    sortedPortfolioDisplay = portfolioDisplay;
    if (portfolioSortType[1]) {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) => (b["price_usd"] * b["total_quantity"]).toDouble().compareTo((a["price_usd"] * a["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) => b[portfolioSortType[0]].compareTo(a[portfolioSortType[0]]));
      }
    } else {
      if (portfolioSortType[0] == "holdings") {
        sortedPortfolioDisplay.sort((a, b) => (a["price_usd"] * a["total_quantity"]).toDouble().compareTo((b["price_usd"] * b["total_quantity"]).toDouble()));
      } else {
        sortedPortfolioDisplay.sort((a, b) => a[portfolioSortType[0]].compareTo(b[portfolioSortType[0]]));
      }
    }
  }

  final PageStorageKey _marketKey = PageStorageKey("market");
  final PageStorageKey _portfolioKey = PageStorageKey("portfolio");

  Widget portfolioPage(BuildContext context) {
    return RefreshIndicator(
        key: _portfolioKey,
        onRefresh: _refreshPortfolioPage,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("total_portfolio_value".tr, style: Theme.of(context).textTheme.caption),
                        Text("\$" + numCommaParse(totalPortfolioStats["value_usd"].toStringAsFixed(2)), style: Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 2.2)),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text("1h_change".tr, style: Theme.of(context).textTheme.caption),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 1.0)),
                        Text(
                            totalPortfolioStats["percent_change_1h"] >= 0
                                ? "+" + totalPortfolioStats["percent_change_1h"].toStringAsFixed(2) + "%"
                                : totalPortfolioStats["percent_change_1h"].toStringAsFixed(2) + "%",
                            style: Theme.of(context).primaryTextTheme.bodyText1.apply(
                                  color: totalPortfolioStats["percent_change_1h"] >= 0 ? Colors.green : Colors.red,
                                  fontSizeFactor: 1.4,
                                ))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("24h_change".tr, style: Theme.of(context).textTheme.caption),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 1.0)),
                        Text(
                            totalPortfolioStats["percent_change_24h"] >= 0
                                ? "+" + totalPortfolioStats["percent_change_24h"].toStringAsFixed(2) + "%"
                                : totalPortfolioStats["percent_change_24h"].toStringAsFixed(2) + "%",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .apply(color: totalPortfolioStats["percent_change_24h"] >= 0 ? Colors.green : Colors.red, fontSizeFactor: 1.4))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "symbol") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["symbol", false];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width * portfolioColumnProps[0],
                        child: portfolioSortType[0] == "symbol"
                            ? Text(portfolioSortType[1] == true ? "${"currency".tr} " + upArrow : "${"currency".tr} " + downArrow, style: Theme.of(context).textTheme.bodyText1)
                            : Text(
                                "currency".tr,
                                style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor),
                              ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "holdings") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["holdings", true];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width * portfolioColumnProps[1],
                        child: portfolioSortType[0] == "holdings"
                            ? Text(portfolioSortType[1] == true ? "${"holdings".tr} " + downArrow : "${"holdings".tr} " + upArrow, style: Theme.of(context).textTheme.bodyText1)
                            : Text("holdings".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (portfolioSortType[0] == "percent_change_24h") {
                          portfolioSortType[1] = !portfolioSortType[1];
                        } else {
                          portfolioSortType = ["percent_change_24h", true];
                        }
                        setState(() {
                          _sortPortfolioDisplay();
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width * portfolioColumnProps[2],
                        child: portfolioSortType[0] == "percent_change_24h"
                            ? Text(portfolioSortType[1] == true ? "${"price_24h".tr} " + downArrow : "${"price_24h".tr} " + upArrow, style: Theme.of(context).textTheme.bodyText1)
                            : Text("price_24h".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ])),
            portfolioMap.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) => PortfolioListItem(sortedPortfolioDisplay[index], portfolioColumnProps),
                        childCount: sortedPortfolioDisplay != null ? sortedPortfolioDisplay.length : 0))
                : SliverFillRemaining(
                    child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("transactions_add".tr, style: Theme.of(context).textTheme.caption),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
                            ElevatedButton(
                              onPressed: _openTransaction,
                              child: Text("transaction".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).iconTheme.color)),
                            )
                          ],
                        ))),
          ],
        ));
  }

  final marketColumnProps = [.32, .35, .28];
  List filteredMarketData;
  Map globalData;

  Future<Null> getGlobalData() async {
    // var response = await http.get(
    //     Uri.encodeFull("https://api.coinmarketcap.com/v1/global-metrics/quotes/latest"),
    //     headers: {"Accept": "application/json"});

    // globalData = JsonDecoder().convert(response.body)["data"]["quotes"]["USD"];
    globalData = null;
  }

  Future<Null> _refreshMarketPage() async {
    await getMarketData();
    await getGlobalData();
    _makePortfolioDisplay();
    _filterMarketData();
    setState(() {});
  }

  _filterMarketData() {
    print("filtering market data");
    filteredMarketData = marketListData;
    if (filter != "" && filter != null) {
      List tempFilteredMarketData = [];
      filteredMarketData.forEach((item) {
        if (item["CoinInfo"]["Name"].toLowerCase().contains(filter.toLowerCase()) || item["CoinInfo"]["FullName"].toLowerCase().contains(filter.toLowerCase())) {
          tempFilteredMarketData.add(item);
        }
      });
      filteredMarketData = tempFilteredMarketData;
    }
    _sortMarketData();
  }

  List marketSortType = ["MKTCAP", true];

  _sortMarketData() {
    if (filteredMarketData == [] || filteredMarketData == null) {
      return;
    }
    // highest to lowest
    if (marketSortType[1]) {
      if (marketSortType[0] == "MKTCAP" || marketSortType[0] == "TOTALVOLUME24H" || marketSortType[0] == "CHANGEPCT24HOUR") {
        print(filteredMarketData);
        filteredMarketData.sort((a, b) => (b["RAW"]["USD"][marketSortType[0]] ?? 0).compareTo(a["RAW"]["USD"][marketSortType[0]] ?? 0));
        if (marketSortType[0] == "MKTCAP") {
          print("adding ranks to filteredMarketData");
          int i = 1;
          for (Map coin in filteredMarketData) {
            coin["rank"] = i;
            i++;
          }
        }
      } else {
        // Handle sorting by name
        filteredMarketData.sort((a, b) => (b["CoinInfo"][marketSortType[0]] ?? 0).compareTo(a["CoinInfo"][marketSortType[0]] ?? 0));
      }
      // lowest to highest
    } else {
      if (marketSortType[0] == "MKTCAP" || marketSortType[0] == "TOTALVOLUME24H" || marketSortType[0] == "CHANGEPCT24HOUR") {
        filteredMarketData.sort((a, b) => (a["RAW"]["USD"][marketSortType[0]] ?? 0).compareTo(b["RAW"]["USD"][marketSortType[0]] ?? 0));
      } else {
        filteredMarketData.sort((a, b) => (a["CoinInfo"][marketSortType[0]] ?? 0).compareTo(b["CoinInfo"][marketSortType[0]] ?? 0));
      }
    }
  }

  Widget marketPage(BuildContext context) {
    return filteredMarketData != null
        ? RefreshIndicator(
            key: _marketKey,
            onRefresh: () => _refreshMarketPage(),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  globalData != null && isSearching != true
                      ? Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("total_market_cap".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 1.0)),
                                  Text("total_24h_volume".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                                ],
                              ),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 1.0)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text("\$" + normalizeNum(globalData["total_market_cap"]),
                                      style: Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 1.2, fontWeightDelta: 2)),
                                  Text("\$" + normalizeNum(globalData["total_volume_24h"]),
                                      style: Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 1.2, fontWeightDelta: 2)),
                                ],
                              )
                            ],
                          ))
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (marketSortType[0] == "Name") {
                              marketSortType[1] = !marketSortType[1];
                            } else {
                              marketSortType = ["Name", false];
                            }
                            setState(() {
                              _sortMarketData();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            width: MediaQuery.of(context).size.width * marketColumnProps[0],
                            child: marketSortType[0] == "Name"
                                ? Text(marketSortType[1] ? "${"currency".tr} " + upArrow : "${"currency".tr} " + downArrow, style: Theme.of(context).textTheme.bodyText1)
                                : Text("currency".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * marketColumnProps[1],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    if (marketSortType[0] == "MKTCAP") {
                                      marketSortType[1] = !marketSortType[1];
                                    } else {
                                      marketSortType = ["MKTCAP", true];
                                    }
                                    setState(() {
                                      _sortMarketData();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: marketSortType[0] == "MKTCAP"
                                        ? Text(marketSortType[1] ? "${"market_cap".tr} " + downArrow : "${"market_cap".tr} " + upArrow,
                                            style: Theme.of(context).textTheme.bodyText1)
                                        : Text("market_cap".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                                  )),
                              Text("/", style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                              InkWell(
                                onTap: () {
                                  if (marketSortType[0] == "TOTALVOLUME24H") {
                                    marketSortType[1] = !marketSortType[1];
                                  } else {
                                    marketSortType = ["TOTALVOLUME24H", true];
                                  }
                                  setState(() {
                                    _sortMarketData();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: marketSortType[0] == "TOTALVOLUME24H"
                                      ? Text(marketSortType[1] ? "24h " + downArrow : "24h " + upArrow, style: Theme.of(context).textTheme.bodyText1)
                                      : Text("24h", style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (marketSortType[0] == "CHANGEPCT24HOUR") {
                              marketSortType[1] = !marketSortType[1];
                            } else {
                              marketSortType = ["CHANGEPCT24HOUR", true];
                            }
                            setState(() {
                              _sortMarketData();
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            width: MediaQuery.of(context).size.width * marketColumnProps[2],
                            child: marketSortType[0] == "CHANGEPCT24HOUR"
                                ? Text(marketSortType[1] == true ? "${"price_24h".tr} " + downArrow : "${"price_24h".tr} " + upArrow, style: Theme.of(context).textTheme.bodyText1)
                                : Text("price_24h".tr, style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).hintColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
                filteredMarketData.isEmpty
                    ? SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                        Container(
                          padding: const EdgeInsets.all(30.0),
                          alignment: Alignment.topCenter,
                          child: Text("empty".tr, style: Theme.of(context).textTheme.caption),
                        )
                      ]))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) => CoinListItem(filteredMarketData[index], marketColumnProps),
                            childCount: filteredMarketData == null ? 0 : filteredMarketData.length))
              ],
            ))
        : Container(
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
