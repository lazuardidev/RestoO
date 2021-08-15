import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/widgets/restaurant_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
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
            SizedBox(
              height: 12,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 60,
              // height: 200,
              child: FutureBuilder<String>(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/local_restaurant.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final restaurant = welcomeFromJson(snapshot.data ?? "");
                    final restaurantElement = restaurant.restaurants;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: restaurantElement.length,
                      itemBuilder: (context, index) {
                        return RestaurantList(
                          context: context,
                          restaurant: restaurantElement[index],
                          menus: restaurantElement[index].menus,
                          food: restaurantElement[index].menus.foods,
                          drink: restaurantElement[index].menus.drinks,
                        );
                      },
                    );
                  } else {
                    Text('Gagal menampilkan data');
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
