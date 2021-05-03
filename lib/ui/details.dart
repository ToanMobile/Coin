import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';
import 'package:wefinex/ui/home_webview_screen.dart';

class details extends StatefulWidget {
  //

  final String title = 'RSS Feed Demo';
  String url;

  // In the constructor, require a Todo
  details(this.url) : super();
  @override
  detailsState createState() => detailsState();
}

class detailsState extends State<details> {
  //
//  static const String FEED_URL =
//      'https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss';
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

  load(String urlNew) async {
    updateTitle(loadingFeedMsg);
    loadFeed(urlNew).then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }

  Future<RssFeed> loadFeed(String urlNew) async {
    try {
      final client = http.Client();
      final response = await client.get(urlNew);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load(widget.url);
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
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
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
      itemCount: _feed.items != null ? _feed.items.length : 0,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: title(item.title != null ? item.title : Container()),
            // subtitle: title(item.pubDate != null ? item.pubDate : Container()),
            leading: thumbnail(palceholderImg),
            trailing: rightIcon(),
            contentPadding: EdgeInsets.all(5.0),
            // onTap: () => openFeed(item.link),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeWebViewScreen(item.link),
              ),
            ),
          ),
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(widget.url),
          );
  }

  @override
  Widget build(BuildContext context) {
    load(widget.url);
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Kết Quả Xổ Số"),
//      ),
      body: body(),
    );
  }
}
