import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/api/api_service.dart';
import 'package:restoo/data/models/restaurant.dart';
// import 'package:restoo/pages/search_page.dart';
import 'package:restoo/widgets/restaurant_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  static bool isConnect = false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<RestaurantApi> _restaurantList;
  Future<RestaurantApi>? _searchRestaurant;
  TextEditingController searchController = TextEditingController(text: "");
  // bool isConnect = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      // body: _buildHomePage(context),
      body: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (_, snapshot) => snapshot.hasData
            ? _checkInternetConnection(snapshot.data!)
            : Center(
                child: Container(
                  child: Image.asset('assets/vector/no_connection.jpg'),
                ),
                // child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _checkInternetConnection(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.mobile) {
      print("MOBILE INTERNET CONNECTION");
      HomePage.isConnect = true;
      _searchRestaurant = ApiService().searchRestaurant(searchController.text);
      return _buildHomePage(context);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("WIFI INTERNET CONNECTION");
      HomePage.isConnect = true;
      _searchRestaurant = ApiService().searchRestaurant(searchController.text);
      return _buildHomePage(context);
    } else {
      print("NO INTERNET CONNECTION");
      HomePage.isConnect = false;
      return Center(
        child: Container(
          child: Image.asset('assets/vector/no_connection.jpg'),
        ),
      );
    }
  }

  SafeArea _buildHomePage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Resto O",
              style: blackTextStyle.copyWith(fontSize: 24),
            ),
            Text(
              "Find best restaurants for you",
              style: greyTextStyle.copyWith(fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: lightGreyColor,
              ),
              child: TextField(
                controller: searchController,
                autofocus: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: greyTextStyle,
                  hintText: 'Search .....',
                  suffixIcon: Icon(
                    Icons.search,
                    color: greyColor,
                  ),
                ),
                onSubmitted: (searchController) {
                  if (HomePage.isConnect) {
                    setState(() {
                      _searchRestaurant = ApiService().searchRestaurant(searchController);
                    });
                  }
                  print("CONNECTIVITY : " + HomePage.isConnect.toString());
                  print("SUBMIT SEARCH");
                },
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              child: _searchList(context),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchList(BuildContext context) {
    return FutureBuilder(
      future: _searchRestaurant,
      builder: (context, AsyncSnapshot<RestaurantApi> snapshot) {
        var state = snapshot.connectionState;
        if (state == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data?.founded == 0) {
              return Center(
                // child: Text('Not Found'),
                child: Container(
                  child: Image.asset('assets/vector/no_data.png'),
                ),
              );
            } else {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.restaurants?.length,
                itemBuilder: (context, index) {
                  var restaurant = snapshot.data?.restaurants?[index];
                  return RestaurantList(
                    context: context,
                    restaurant: restaurant!,
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Text('-');
          }
        }
      },
    );
  }

  // Widget _buildList(BuildContext context) {
  //   return FutureBuilder(
  //     future: _restaurantList,
  //     builder: (context, AsyncSnapshot<RestaurantApi> snapshot) {
  //       var state = snapshot.connectionState;
  //       if (state != ConnectionState.done) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else {
  //         if (snapshot.hasData) {
  //           return ListView.builder(
  //             physics: NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             itemCount: snapshot.data?.restaurants?.length,
  //             itemBuilder: (context, index) {
  //               var restaurant = snapshot.data?.restaurants?[index];
  //               return RestaurantList(
  //                 context: context,
  //                 restaurant: restaurant!,
  //               );
  //             },
  //           );
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text(snapshot.error.toString()));
  //         } else {
  //           return Text('');
  //         }
  //       }
  //     },
  //   );
  // }

}
