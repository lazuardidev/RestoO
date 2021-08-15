import 'package:flutter/material.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/pages/detail_page.dart';
import 'package:restoo/pages/home_page.dart';
import 'package:restoo/pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resto O',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomePage.routeName,
      routes: {
        WelcomePage.routeName: (context) => WelcomePage(),
        HomePage.routeName: (context) => HomePage(),
        DetailPage.routeName: (context) => DetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant,
            ),
      },
    );
  }
}
