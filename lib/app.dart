import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/index.dart';
import 'package:kite/util/page_logger.dart';

final _routes = {
  '/home': (context) => const HomePage(),
  '/report': (context) => const DailyReportPage(),
  '/login': (context) => const LoginPage(),
  '/welcome': (context) => const WelcomePage(),
  '/about': (context) => const AboutPage(),
  '/expense': (context) => const ExpensePage(),
  '/connectivity': (context) => const ConnectivityPage(),
  '/campusCard': (context) => CampusCardPage(),
  '/electricity': (context) => const ElectricityPage(),
  '/score': (context) => const ScorePage(),
  '/office': (context) => const OfficePage(),
  '/game': (context) => const GamePage(),
  '/wiki': (context) => const WikiPage(),
  '/library': (context) => const LibraryPage(),
  '/market': (context) => const MarketPage(),
  '/timetable': (context) => const TimetablePage(),
  '/setting': (context) => const SettingPage(),
  '/feedback': (context) => const FeedbackPage(),
  '/notice': (context) => const NoticePage(),
  '/contact': (context) => const ContactPage(),
};

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = StoragePool.themeSetting.color;
    final themeData = ThemeData(primaryColor: primaryColor, primarySwatch: createThemeSwatch(primaryColor));

    final home = StoragePool.authSetting.currentUsername != null ? const HomePage() : const WelcomePage();
    return ScreenUtilInit(
      builder: () => MaterialApp(
        navigatorKey: Catcher.navigatorKey,
        title: '上应小风筝',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        home: home,
        onGenerateRoute: onGenerateRoute,
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return widget!;
        },
      ),
    );
  }
}

MaterialColor createThemeSwatch(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  pageLogger.page(settings.name ?? 'Unknown');
  return MaterialPageRoute(
    builder: (context) => _routes[settings.name]!(context),
    settings: settings,
  );
}
