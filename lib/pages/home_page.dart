import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/main.dart';
import 'package:restoo/provider/restaurant_provider.dart';
import 'package:restoo/widgets/restaurant_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  // static bool isConnect = false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<RestaurantApi>? _restaurantApi;
  TextEditingController searchController = TextEditingController(text: "");

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
      body: (MyApp.isConnect == true)
          ? _buildHomePage(context)
          : Center(
              child: Image.asset('assets/vector/no_connection.jpg'),
            ),
    );
  }

  Widget _checkInternetConnection(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.mobile) {
      // print("MOBILE INTERNET CONNECTION");
      MyApp.isConnect = true;
      // _restaurantApi = ApiService().searchRestaurant(searchController.text);
      return _buildHomePage(context);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // print("WIFI INTERNET CONNECTION");
      MyApp.isConnect = true;
      // _restaurantApi = ApiService().searchRestaurant(searchController.text);
      return _buildHomePage(context);
    } else {
      // print("NO INTERNET CONNECTION");
      MyApp.isConnect = false;
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
              child: Consumer<RestaurantProvider>(
                builder: (context, state, _) => TextField(
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
                    onSubmitted: (searchText) {
                      if (MyApp.isConnect) {
                        state.searchRestaurantProvider(query: searchText);
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              child: Consumer<RestaurantProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == ResultState.HasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.result.restaurants?.length,
                        itemBuilder: (context, index) {
                          var restaurant = state.result.restaurants?[index];
                          if (restaurant != null) {
                            return RestaurantList(
                              context: context,
                              restaurant: restaurant,
                            );
                          }
                          return Text('');
                        });
                  } else if (state.state == ResultState.NoData) {
                    return Center(child: Text(state.message));
                  } else if (state.state == ResultState.Error) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text(''));
                  }
                },
                // return _buildMyHomePage();
              ),
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
      future: _restaurantApi,
      builder: (context, AsyncSnapshot<RestaurantApi> snapshot) {
        var state = snapshot.connectionState;
        if (state == ConnectionState.waiting) {
          return Center(
            // child: CircularProgressIndicator(),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: LottieBuilder.asset('assets/loading_animation.json'),
            ),
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

  Widget _buildMyHomePage() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.result.restaurants?.length,
              itemBuilder: (context, index) {
                var restaurant = state.result.restaurants?[index];
                if (restaurant != null) {
                  return RestaurantList(
                    context: context,
                    restaurant: restaurant,
                  );
                }
                return Text('');
              });
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }

}
