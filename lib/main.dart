import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoo/data/api/api_service.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/pages/detail_page.dart';
import 'package:restoo/pages/home_page.dart';
import 'package:restoo/pages/welcome_page.dart';
import 'package:restoo/provider/restaurant_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool isConnect = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(
        apiService: ApiService(),
      ),
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            _checkInternetConnection(snapshot.data!);
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Resto O',
            theme: ThemeData(
              primarySwatch: Colors.green,
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
      ),
    );
  }

  void _checkInternetConnection(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnect = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnect = true;
    } else {
      isConnect = false;
    }
  }
}
