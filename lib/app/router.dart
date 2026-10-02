import 'package:flutter/material.dart';

import '../presentation/calendar/calendar_page.dart';
import '../presentation/home/home_page.dart';
import '../presentation/settings/settings_page.dart';

class AppRouter {
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String settingsPage = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const LiturgicalHomePage());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
