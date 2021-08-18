import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/api/api_service.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/widgets/restaurant_list.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<RestaurantApi>? _searchRestaurant;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
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
                "Search",
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
                  autofocus: true,
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
                    _searchRestaurant =
                        ApiService().searchRestaurant(searchController);
                    setState(() {});
                    print("SUBMIT SEARCH");
                  },
                ),
              ),
              SizedBox(
                height: 20,
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
      ),
    );
  }

  Widget _searchList(BuildContext context) {
    return FutureBuilder(
      future: _searchRestaurant,
      builder: (context, AsyncSnapshot<RestaurantApi> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done && searchController.text.isNotEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data?.founded == 0) {
              return Text('Not Found');
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
}
