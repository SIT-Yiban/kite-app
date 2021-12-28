import 'package:flutter/material.dart';
import 'package:kite/pages/login_page.dart';

import 'package:kite/pages/home_page.dart';
import 'package:kite/routes/welcome.dart';
import 'package:kite/pages/report_page.dart';

void main() => runApp(const KiteApp());

class KiteApp extends StatelessWidget {
  const KiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '上应小风筝',
      theme: ThemeData.light(),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/dailyReport': (context) => const DailyReportPage(),
        '/welcome': (context) => const IntroductionAnimationScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
