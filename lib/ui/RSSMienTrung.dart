import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:wefinex/ui//details.dart';

import 'Todo.dart';

class RSSMienTrung extends StatefulWidget {
  //
  RSSMienTrung() : super();

  final String title = 'Xổ Số';

  @override
  RSSDemoState createState() => RSSDemoState();
}

class RSSDemoState extends State<RSSMienTrung> {
  //
  static List<Todo> todos = [
    Todo(
        "Xổ Số Miền Trung", "https://xskt.com.vn/rss-feed/mien-trung-xsmt.rss"),
    Todo("Xổ Số Bình Định", "https://xskt.com.vn/rss-feed/binh-dinh-xsbdi.rss"),
    Todo("Xổ Số Đắc Lắc", "https://xskt.com.vn/rss-feed/dac-lac-xsdlk.rss"),
    Todo("Xổ Số Đà Nẵng", "https://xskt.com.vn/rss-feed/da-nang-xsdng.rss"),
    Todo("Xổ Số Đắc Nông", "https://xskt.com.vn/rss-feed/dac-nong-xsdno.rss"),
    Todo("Xổ Số Gia Lai", "https://xskt.com.vn/rss-feed/gia-lai-xsgl.rss"),
    Todo("Xổ Số Khánh Hòa", "https://xskt.com.vn/rss-feed/khanh-hoa-xskh.rss"),
    Todo("Xổ Số Kon Tum", "https://xskt.com.vn/rss-feed/kon-tum-xskt.rss"),
    Todo(
        "Xổ Số Ninh Thuận", "https://xskt.com.vn/rss-feed/ninh-thuan-xsnt.rss"),
    Todo("Xổ Số Phú Yên", "https://xskt.com.vn/rss-feed/phu-yen-xspy.rss"),
    Todo(
        "Xổ Số Quảng Bình", "https://xskt.com.vn/rss-feed/quang-binh-xsqb.rss"),
    Todo("Xổ Số Quảng Ngãi",
        "https://xskt.com.vn/rss-feed/quang-ngai-xsqng.rss"),
    Todo("Xổ Số Quảng Nam", "https://xskt.com.vn/rss-feed/quang-nam-xsqnm.rss"),
    Todo("Xổ Số Quảng Trị", "https://xskt.com.vn/rss-feed/quang-tri-xsqt.rss"),
    Todo("Xổ Số Thừa Thiên Huế",
        "https://xskt.com.vn/rss-feed/thua-thien-hue-xstth.rss"),
  ];
  static const String FEED_URL =
      'https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss';
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
