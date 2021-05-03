import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart_two/flutter_circular_chart_two.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../trace/sparkline.dart';
import 'breakdown_item.dart';
import 'transaction_item.dart';

class PortfolioTabs extends StatefulWidget {
  PortfolioTabs(this.tab, this.makePortfolioDisplay);

  final int tab;
  final Function makePortfolioDisplay;

  @override
  PortfolioTabsState createState() => PortfolioTabsState();
}

class PortfolioTabsState extends State<PortfolioTabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(widget.tab);
    if (timelineData == null) {
      _getTimelineData();
    }
    _makeColorMap();
    _updateBreakdown();
    _sortPortfolioDisplay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            titleSpacing: 0.0,
            elevation: appBarElevation,
            title: Text("portfolio".tr, style: Theme.of(context).textTheme.title),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(25.0),
                child: Container(
                    height: 30.0,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).accentIconTheme.color,
                      indicatorWeight: 2.0,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      labelColor: Theme.of(context).primaryIconTheme.color,
                      tabs: <Widget>[
                        Tab(text: "timeline".tr),
                        Tab(text: "breakdown".tr),
                      ],
                    ))),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[_timeline(context), _breakdown(context)],
        ));
  }

  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();

  num value = 0;
  List<double> timelineData;
  num high = 0;
  num low = 0;
  num changePercent = 0;
  num changeAmt = 0;
  String periodSetting = "24h";

  final Map periodOptions = {
    "24h": {"limit": 96, "aggregate_by": 15, "hist_type": "minute", "unit_in_ms": 900000},
    "3D": {"limit": 72, "aggregate_by": 1, "hist_type": "hour", "unit_in_ms": 3600000},
    "7D": {"limit": 86, "aggregate_by": 2, "hist_type": "hour", "unit_in_ms": 3600000 * 2},
    "1M": {"limit": 90, "aggregate_by": 8, "hist_type": "hour", "unit_in_ms": 3600000 * 8},
    "3M": {"limit": 90, "aggregate_by": 1, "hist_type": "day", "unit_in_ms": 3600000 * 24},
    "6M": {"limit": 90, "aggregate_by": 2, "hist_type": "day", "unit_in_ms": 3600000 * 24 * 2},
    "1Y": {"limit": 73, "aggregate_by": 5, "hist_type": "day", "unit_in_ms": 3600000 * 24 * 5},
    "All": {"limit": 0, "aggregate_by": 1, "hist_type": "day", "unit_in_ms": 3600000 * 24}
  };

  List<Map> transactionList;

  Future<Null> _refresh() async {
    await _getTimelineData();
    widget.makePortfolioDisplay();
    _updateBreakdown();
    _sortPortfolioDisplay();
    if (_tabController.index == 1) {
      _chartKey.currentState.updateData([CircularStackEntry(segments, rankKey: "Portfolio Breakdown")]);
    }
    setState(() {});
  }

  Map<int, double> timedData;
  DateTime oldestPoint = DateTime.now();
  List<int> times;

  _getTimelineData() async {
    value = totalPortfolioStats["value_usd"];

    timedData = {};
    List<Future> futures = [];
    times = [];

    portfolioMap.forEach((symbol, transactions) {
      num oldest = double.infinity;
      transactions.forEach((transaction) {
        if (transaction["time_epoch"] < oldest) {
          oldest = transaction["time_epoch"];
        }
      });

      futures.add(_pullData({"symbol": symbol, "oldest": oldest}));
      times.add(oldest);
    });

    await Future.wait(futures);
    _finalizeTimelineData();
  }

  Future<Null> _pullData(coin) async {
    int msAgo = DateTime.now().millisecondsSinceEpoch - coin["oldest"];
    int limit = periodOptions[periodSetting]["limit"];
    int periodInMs = limit * periodOptions[periodSetting]["unit_in_ms"];

    if (periodSetting == "All") {
      limit = msAgo ~/ periodOptions[periodSetting]["unit_in_ms"];
    } else if (msAgo < periodInMs) {
      limit = limit - ((periodInMs - msAgo) ~/ periodOptions[periodSetting]["unit_in_ms"]);
    }

    var response = await http.get(
        Uri.tryParse("https://min-api.cryptocompare.com/data/histo" +
            periodOptions[periodSetting]["hist_type"].toString() +
            "?fsym=" +
            coin["symbol"] +
            "&tsym=USD&limit=" +
            limit.toString() +
            "&aggregate=" +
            periodOptions[periodSetting]["aggregate_by"].toString()),
        headers: {"Accept": "application/json"});

    List responseData = json.decode(response.body)["Data"];

    responseData.forEach((point) {
      num averagePrice = (point["open"] + point["close"]) / 2;

      portfolioMap[coin["symbol"]].forEach((transaction) {
        if (timedData[point["time"]] == null) {
          timedData[point["time"]] = 0.0;
        }

        if (transaction["time_epoch"] - 900000 < point["time"] * 1000) {
          timedData[point["time"]] += (transaction["quantity"] * averagePrice).toDouble();
        }
      });
    });
  }

  _finalizeTimelineData() {
    int oldestInData = times.reduce(min);
    int oldestInRange = DateTime.now().millisecondsSinceEpoch - periodOptions[periodSetting]["unit_in_ms"] * periodOptions[periodSetting]["limit"];

    if (oldestInData > oldestInRange || periodSetting == "All") {
      oldestPoint = DateTime.fromMillisecondsSinceEpoch(oldestInData);
    } else {
      oldestPoint = DateTime.fromMillisecondsSinceEpoch(oldestInRange);
    }

    timelineData = [];
    timedData.keys.toList()
      ..sort()
      ..forEach((key) => timelineData.add(timedData[key]));

    high = timelineData.reduce(max);
    low = timelineData.reduce(min);

    num start = timelineData[0] != 0 ? timelineData[0] : 1;
    num end = timelineData.last;
    changePercent = (end - start) / start * 100;
    changeAmt = end - start;

    setState(() {});
  }

  _makeTransactionList() {
    transactionList = [];
    portfolioMap.forEach((symbol, transactions) {
      num currentPrice;
      for (Map coin in marketListData) {
        if (coin["CoinInfo"]["Name"] == symbol) {
          currentPrice = coin["RAW"]["USD"]["PRICE"];
          break;
        }
      }

      transactions.forEach((transaction) => transactionList.add({"snapshot": transaction, "current_price": currentPrice, "symbol": symbol}));

      transactionList.sort((a, b) => b["snapshot"]["time_epoch"].compareTo(a["snapshot"]["time_epoch"]));
    });
  }

  Widget _timeline(BuildContext context) {
    _makeTransactionList();
    return portfolioMap.isNotEmpty
        ? RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("portfolio_value".tr, style: Theme.of(context).textTheme.caption),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text("\$" + numCommaParse(value.toStringAsFixed(2)), style: Theme.of(context).textTheme.body2.apply(fontSizeFactor: 2.2)),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 3.0)),
                              timelineData != null
                                  ? PercentDollarChange(
                                      percent: changePercent,
                                      exact: changeAmt,
                                    )
                                  : Container(),
                            ],
                          ),
//                          Padding(padding: const EdgeInsets.symmetric(vertical: 2.5)),
                          timelineData != null
                              ? Row(
                                  children: <Widget>[
                                    Text("high".tr, style: Theme.of(context).textTheme.caption),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0)),
                                    Text("\$" + normalizeNum(high), style: Theme.of(context).textTheme.body2.apply(fontSizeFactor: 1.1))
                                  ],
                                )
                              : Container(),
                          timelineData != null
                              ? Row(
                                  children: <Widget>[
                                    Text("low".tr, style: Theme.of(context).textTheme.caption),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 3.0)),
                                    Text("\$" + normalizeNum(low), style: Theme.of(context).textTheme.body2.apply(fontSizeFactor: 1.1))
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Card(
                        elevation: 2.0,
                        child: Container(
                          margin: const EdgeInsets.only(left: 14.0, bottom: 12.0),
                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(periodSetting, style: Theme.of(context).textTheme.body2.apply(fontWeightDelta: 2, fontSizeFactor: 1.2)),
                                  Container(
                                    child: PopupMenuButton(
                                      icon: Icon(Icons.access_time, color: Theme.of(context).buttonColor),
                                      tooltip: "select_period".tr,
                                      itemBuilder: (context) {
                                        List<PopupMenuEntry<dynamic>> options = [];
                                        periodOptions.forEach((K, V) => options.add(PopupMenuItem(child: Text(K), value: K)));
                                        return options;
                                      },
                                      onSelected: (chosen) {
                                        setState(() {
                                          periodSetting = chosen;
                                          timelineData = null;
                                        });
                                        _getTimelineData();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 14.0),
                                child: Text(
                                    "${oldestPoint.month.toString()}/${oldestPoint.day.toString()}"
                                    "/${oldestPoint.year.toString().substring(2)} ➞ ${"now".tr}",
                                    style: Theme.of(context).textTheme.body2.apply(fontSizeFactor: .9)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ])),
                Container(
                  padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 2.0),
                  height: MediaQuery.of(context).size.height * .6,
                  child: timelineData != null
                      ? Container(
                          child: timelineData.last != 0.0
                              ? Sparkline(
                                  data: timelineData,
                                  lineGradient:
                                      LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Theme.of(context).buttonColor, Colors.purpleAccent[100]]),
                                  enableGridLines: true,
                                  gridLineColor: Theme.of(context).dividerColor,
                                  gridLineLabelColor: Theme.of(context).hintColor,
                                  gridLineAmount: 4,
                                )
                              : Container(alignment: Alignment.center, child: Text("transactions_future".tr, style: Theme.of(context).textTheme.caption)))
                      : Container(alignment: Alignment.center, child: CircularProgressIndicator()),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0, left: 8.0, bottom: 4.0),
                  child: Text("transactions_all".tr, style: Theme.of(context).textTheme.caption),
                )
              ])),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => TransactionItem(
                            symbol: transactionList[index]["symbol"],
                            currentPrice: transactionList[index]["current_price"],
                            snapshot: transactionList[index]["snapshot"],
                            refreshPage: () => _refresh(),
                          ),
                      childCount: transactionList.length))
            ]),
          )
        : Container(
            alignment: Alignment.topCenter, padding: const EdgeInsets.symmetric(vertical: 40.0), child: Text("transactions_add".tr, style: Theme.of(context).textTheme.caption));
  }

  final columnProps = [.2, .3, .3];
  final List colors = [
    Colors.purple[400],
    Colors.indigo[400],
    Colors.blue[400],
    Colors.teal[400],
    Colors.green[400],
    Colors.lime[400],
    Colors.orange[400],
    Colors.red[400],
  ];

  num net;
  num netPercent;
  num cost;
  List<CircularSegmentEntry> segments;
  Map colorMap;

  _updateBreakdown() {
    cost = 0;
    net = 0;
    netPercent = 0;

    portfolioMap.forEach((symbol, transactions) {
      transactions.forEach((transaction) {
        cost += transaction["quantity"] * transaction["price_usd"];
      });
    });

    net = value - cost;

    if (cost > 0) {
      netPercent = ((value - cost) / cost) * 100;
    } else {
      netPercent = 0.0;
    }
  }

  _makeSegments() {
    segments = [];
    sortedPortfolioDisplay.forEach((coin) {
      segments.add(CircularSegmentEntry(coin["total_quantity"] * coin["price_usd"], colorMap[coin["symbol"]], rankKey: coin["symbol"]));
    });
  }

  _makeColorMap() {
    colorMap = {};
    int colorIndex = 0;
    portfolioDisplay.forEach((coin) {
      if (colorIndex >= colors.length) {
        colorIndex = 1;
      }
      colorMap[coin["symbol"]] = colors[colorIndex];
      colorIndex += 1;
    });
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
    _makeSegments();
  }

  Widget _breakdown(BuildContext context) {
    return portfolioMap.isNotEmpty
        ? RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("total_value".tr, style: Theme.of(context).textTheme.caption),
                            Row(
                              children: <Widget>[
                                Text("\$" + numCommaParse(value.toStringAsFixed(2)), style: Theme.of(context).textTheme.body2.apply(fontSizeFactor: 2.2)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("total_net".tr, style: Theme.of(context).textTheme.caption),
                            PercentDollarChange(
                              exact: net,
                              percent: netPercent,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("total_cost".tr, style: Theme.of(context).textTheme.caption),
                            Text("\$" + numCommaParse(cost.toStringAsFixed(2)), style: Theme.of(context).primaryTextTheme.body2.apply(fontSizeFactor: 1.4))
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedCircularChart(
                    key: _chartKey,
                    initialChartData: <CircularStackEntry>[CircularStackEntry(segments, rankKey: "Portfolio Breakdown")],
                    size: Size.square(MediaQuery.of(context).size.width * 0.75),
                    duration: Duration(milliseconds: 500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              _chartKey.currentState.updateData([CircularStackEntry(segments, rankKey: "Portfolio Breakdown")]);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            width: MediaQuery.of(context).size.width * columnProps[0],
                            child: portfolioSortType[0] == "symbol"
                                ? Text(portfolioSortType[1] == true ? "${"currency".tr} ⬆" : "${"currency".tr} ⬇", style: Theme.of(context).textTheme.body2)
                                : Text(
                                    "currency".tr,
                                    style: Theme.of(context).textTheme.body2.apply(color: Theme.of(context).hintColor),
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
                              _chartKey.currentState.updateData([CircularStackEntry(segments, rankKey: "Portfolio Breakdown")]);
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            width: MediaQuery.of(context).size.width * columnProps[1],
                            child: portfolioSortType[0] == "holdings"
                                ? Text(portfolioSortType[1] == true ? "${"holdings".tr} ⬇" : "${"holdings".tr} ⬆", style: Theme.of(context).textTheme.body2)
                                : Text("holdings".tr, style: Theme.of(context).textTheme.body2.apply(color: Theme.of(context).hintColor)),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * columnProps[2],
                          child: Text("percent_of_total".tr, style: Theme.of(context).textTheme.body2.apply(color: Theme.of(context).hintColor)),
                        ),
                      ],
                    ),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => PortfolioBreakdownItem(
                            snapshot: sortedPortfolioDisplay[index], totalValue: totalPortfolioStats["value_usd"], color: colorMap[sortedPortfolioDisplay[index]["symbol"]]),
                        childCount: sortedPortfolioDisplay.length)),
              ],
            ),
          )
        : Container(
            alignment: Alignment.topCenter, padding: const EdgeInsets.symmetric(vertical: 40.0), child: Text("transactions_add".tr, style: Theme.of(context).textTheme.caption));
  }
}

class PercentDollarChange extends StatelessWidget {
  PercentDollarChange({this.percent, this.exact});

  final num percent;
  final num exact;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      (percent ?? 0) > 0
          ? TextSpan(text: "+${(percent ?? 0).toStringAsFixed(2)}%\n", style: Theme.of(context).textTheme.body2.apply(color: Colors.green, fontSizeFactor: 1.1))
          : TextSpan(text: "${(percent ?? 0).toStringAsFixed(2)}%\n", style: Theme.of(context).textTheme.body2.apply(color: Colors.red, fontSizeFactor: 1.1)),
      (exact ?? 0) > 0
          ? TextSpan(text: "(\$${normalizeNum(exact)})", style: Theme.of(context).textTheme.body1.apply(color: Colors.green, fontSizeFactor: 1.0))
          : TextSpan(text: "(\$${normalizeNum(exact)})", style: Theme.of(context).textTheme.body1.apply(color: Colors.red, fontSizeFactor: 1.0)),
    ]));
  }
}
