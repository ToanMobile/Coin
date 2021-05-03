import 'package:flutter/material.dart';
import 'package:wefinex/ui/contact_data.dart';
import 'package:wefinex/ui/home_link_screen.dart';
//import 'home_rss_screen.dart';
import 'package:wefinex/ui/home_screen.dart';
import 'package:wefinex/ui/not_found_page.dart';

class RouteGenerator {
  static Route authorizedRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/Main':
        return _buildRoute(settings, Home());
      case '/home':
        return _buildRoute(settings, HomeLinkScreen(settings.arguments));
      case '/support':
        return _buildRoute(settings, ContactData());
      default:
        return _buildRouteDialog(settings, NotFoundPage());
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }

  static MaterialPageRoute _buildRouteDialog(
      RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      fullscreenDialog: true,
      builder: (BuildContext context) => builder,
    );
  }
}
