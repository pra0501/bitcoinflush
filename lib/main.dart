import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'portfolio_page.dart';
import 'trendsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // final FirebaseAnalytics analytics = FirebaseAnalytics();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        //FirebaseAnalyticsObserver(analytics: analytics)
      ],
      title: 'Bitcoin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      routes: <String, WidgetBuilder>{
        '/myHomePage': (BuildContext context) => MyHomePage(),
        '/homePage': (BuildContext context) => TrendsPage(),
        '/portPage': (BuildContext context) => PortfolioPage(),
        '/trendPage': (BuildContext context) => TrendsPage(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/image/Splash.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
            ),

          ],
        ));
  }

  @override
  void initState() {
    homePage();
    super.initState();

  }



  Future<void> homePage() async {
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      Navigator.of(context).pushReplacementNamed('/homePage');
    });
  }
}
