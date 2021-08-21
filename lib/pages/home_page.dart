import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/main.dart';
import 'package:restoo/provider/restaurant_provider.dart';
import 'package:restoo/widgets/restaurant_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: (MyApp.isConnect == true)
          ? _buildHomePage(context)
          : Center(
              child: Image.asset('assets/vector/no_connection.jpg'),
            ),
    );
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
                  },
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              child: Consumer<RestaurantProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    return Center(
                      child:
                          LottieBuilder.asset('assets/loading_animation.json'),
                    );
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
                      },
                    );
                  } else if (state.state == ResultState.NoData) {
                    return Center(
                      child: Image.asset('assets/vector/no_data.png'),
                    );
                  } else if (state.state == ResultState.Error) {
                    return Center(
                      child: Image.asset('assets/vector/something_wrong.png'),
                    );
                  } else {
                    return Center(
                      child: Text(''),
                    );
                  }
                },
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
}
