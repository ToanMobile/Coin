import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:wefinex/ui//details.dart';

import 'Todo.dart';

class RSSMienNam extends StatefulWidget {
  //
  RSSMienNam() : super();

  final String title = 'Xổ Số';

  @override
  RSSDemoState createState() => RSSDemoState();
}

class RSSDemoState extends State<RSSMienNam> {
  //
  static List<Todo> todos = [
    Todo("Xổ Số Miền Nam", "https://xskt.com.vn/rss-feed/mien-nam-xsmn.rss"),
    Todo("Xổ Số An Giang", "https://xskt.com.vn/rss-feed/an-giang-xsag.rss"),
    Todo(
        "Xổ Số Bình Dương", "https://xskt.com.vn/rss-feed/binh-duong-xsbd.rss"),
    Todo("Xổ Số Bạc Liêu", "https://xskt.com.vn/rss-feed/bac-lieu-xsbl.rss"),
    Todo(
        "Xổ Số Bình Phước", "https://xskt.com.vn/rss-feed/binh-phuoc-xsbp.rss"),
    Todo("Xổ Số Bến Tre", "https://xskt.com.vn/rss-feed/ben-tre-xsbt.rss"),
    Todo("Xổ Số Bình Thuận",
        "https://xskt.com.vn/rss-feed/binh-thuan-xsbth.rss"),
    Todo("Xổ Số Cà Mau", "https://xskt.com.vn/rss-feed/ca-mau-xscm.rss"),
    Todo("Xổ Số Cần Thơ", "https://xskt.com.vn/rss-feed/can-tho-xsct.rss"),
    Todo("Xổ Số Đồng Nai", "https://xskt.com.vn/rss-feed/dong-nai-xsdn.rss"),
    Todo("Xổ Số Đồng Tháp", "https://xskt.com.vn/rss-feed/dong-thap-xsdt.rss"),
    Todo("Xổ Số TP.HCM", "https://xskt.com.vn/rss-feed/tp-hcm-xshcm.rss"),
    Todo("Xổ Số Hậu Giang", "https://xskt.com.vn/rss-feed/hau-giang-xshg.rss"),
    Todo(
        "Xổ Số Kiên Giang", "https://xskt.com.vn/rss-feed/kien-giang-xskg.rss"),
    Todo("Xổ Số Long An", "https://xskt.com.vn/rss-feed/long-an-xsla.rss"),
    Todo("Xổ Số Lâm Đồng", "https://xskt.com.vn/rss-feed/lam-dong-xsld.rss"),
    Todo("Xổ Số Sóc Trăng", "https://xskt.com.vn/rss-feed/soc-trang-xsst.rss"),
    Todo(
        "Xổ Số Tiền Giang", "https://xskt.com.vn/rss-feed/tien-giang-xstg.rss"),
    Todo("Xổ Số Tây Ninh", "https://xskt.com.vn/rss-feed/tay-ninh-xstn.rss"),
    Todo("Xổ Số Trà Vinh", "https://xskt.com.vn/rss-feed/tra-vinh-xstv.rss"),
    Todo("Xổ Số Vĩnh Long", "https://xskt.com.vn/rss-feed/vinh-long-xsvl.rss"),
    Todo("Xổ Số Vũng Tàu", "https://xskt.com.vn/rss-feed/vung-tau-xsvt.rss"),
  ];

  RssFeed _feed;
  String _title;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String palceholderImg = 'assets/images/xoso.jpeg';
  GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

//  load() async {
//    updateTitle(loadingFeedMsg);
//    loadFeed().then((result) {
//      if (null == result || result.toString().isEmpty) {
//        updateTitle(feedLoadErrorMsg);
//        return;
//      }
//      updateFeed(result);
//      updateTitle(_feed.title);
//    });
//  }

//  Future<RssFeed> loadFeed() async {
//    try {
//      final client = http.Client();
//      final response = await client.get(todos);
//      return RssFeed.parse(response.body);
//    } catch (e) {
//      //
//    }
//    return null;
//  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
//    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(palceholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: title(todos[index].title),
            leading: thumbnail(palceholderImg),
            trailing: rightIcon(),
            contentPadding: EdgeInsets.all(5.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => details(todos[index].link),
                ),
              );
            },
          ),
        );
      },
    );
  }

  isFeedEmpty() {
    return false;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => Future.any(null), //load(listRss[0].link),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
