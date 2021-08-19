import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/api/api_service.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/main.dart';
import 'package:restoo/widgets/rating_star.dart';
import 'package:restoo/widgets/review_list.dart';

import 'home_page.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail_page';

  final Restaurant restaurant;

  const DetailPage({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RestaurantApi> _restaurantApi;
  TextEditingController reviewController = TextEditingController(text: "");

  String address = "";
  List<Category> category = [];
  List<Category> foods = [];
  List<Category> drinks = [];
  List<CustomerReview> customerReviews = [];

  List<String> categoryList = [];
  List<String> foodList = [];
  List<String> drinkList = [];
  List<CustomerReview> listCustomerReviews = [];

  bool isFavorite = false;
  // bool isConnect = false;

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (MyApp.isConnect == true) {
      _restaurantApi = ApiService().restaurantDetail(id: widget.restaurant.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: (MyApp.isConnect == true)
          ? _buildDetailPage(context)
          : Container(
              child: Image.asset('assets/vector/no_connection.jpg'),
            ),
      // body: StreamBuilder<ConnectivityResult>(
      //   stream: Connectivity().onConnectivityChanged,
      //   builder: (_, snapshot) => snapshot.hasData
      //       ? _checkInternetConnection(snapshot.data!)
      //       : Center(
      //         child: CircularProgressIndicator(),
      //           // child: Container(
      //           //   child: Image.asset('assets/vector/no_connection.jpg'),
      //           // ),
      //         ),
      // ),
    );
  }

  // Widget _checkInternetConnection(ConnectivityResult connectivityResult) {
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     print("MOBILE INTERNET CONNECTION");
  //     HomePage.isConnect = true;
  //     _restaurantApi = ApiService().restaurantDetail(id: widget.restaurant.id);
  //     return _buildDetailPage(context);
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     print("WIFI INTERNET CONNECTION");
  //     HomePage.isConnect = true;
  //     _restaurantApi = ApiService().restaurantDetail(id: widget.restaurant.id);
  //     return _buildDetailPage(context);
  //   } else {
  //     print("NO INTERNET CONNECTION");
  //     HomePage.isConnect = false;
  //     return Center(
  //       child: Container(
  //         child: Image.asset('assets/vector/no_connection.jpg'),
  //       ),
  //     );
  //   }
  // }

  getFoods(var list) {
    foodList.clear();
    for (int i = 0; i < list.length; i++) {
      foodList.add(list[i].name);
    }
  }

  getDrinks(var list) {
    drinkList.clear();
    for (int i = 0; i < list.length; i++) {
      drinkList.add(list[i].name);
    }
  }

  getCategory(var list) {
    categoryList.clear();
    for (int i = 0; i < list.length; i++) {
      categoryList.add(list[i].name);
    }
  }

  getCustomerReviews(List<CustomerReview> list) {
    customerReviews.clear();
    for (int i = 0; i < list.length; i++) {
      customerReviews.add(list[i]);
    }
  }

  Widget _buildDetailPage(BuildContext context) {
    return FutureBuilder(
      future: _restaurantApi,
      builder: (context, AsyncSnapshot<RestaurantApi> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return Center(
            // child: CircularProgressIndicator(),
            child: LottieBuilder.asset('assets/loading_animation.json'),
          );
        } else {
          if (snapshot.hasData) {
            address = snapshot.data!.restaurant!.address;
            category = snapshot.data!.restaurant!.categories;
            foods = snapshot.data!.restaurant!.menus.foods;
            drinks = snapshot.data!.restaurant!.menus.drinks;
            customerReviews = snapshot.data!.restaurant!.customerReviews;

            getCategory(category);
            getFoods(foods);
            getDrinks(drinks);
            // getCustomerReviews(customerReviews);
            return Stack(
              children: [
                Hero(
                  tag: widget.restaurant.id,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: 300,
                    imageUrl:
                        "https://restaurant-api.dicoding.dev/images/medium/" +
                            widget.restaurant.pictureId,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SafeArea(
                  child: ListView(
                    // padding: EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // Container(),
                      Container(
                        padding: EdgeInsets.only(left: 24),
                        height: 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black12),
                              child: Image.asset(
                                  'assets/icons/back_arrow_white.png'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 180),
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          134,
                                      child: Text(
                                        widget.restaurant.name,
                                        style: blackTextStyle.copyWith(
                                            fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    RatingStar(rate: widget.restaurant.rating),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   isFavorite = !isFavorite;
                                    // });
                                  },
                                  child: Image.asset(
                                    (isFavorite)
                                        ? 'assets/icons/btn_wishlist_filled.png'
                                        : 'assets/icons/btn_wishlist.png',
                                    width: 40,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              widget.restaurant.description,
                              style: greyTextStyle,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Kategori',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            Container(
                              child: Text(
                                '${categoryList.join(', ')}.',
                                style: greyTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Makanan',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            Container(
                              child: Text(
                                '${foodList.join(', ')}.',
                                style: greyTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Minuman',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            Container(
                              child: Text(
                                '${drinkList.join(', ')}.',
                                style: greyTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Lokasi',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 280,
                                  child: Text(
                                    '${widget.restaurant.city}\n$address',
                                    style: greyTextStyle.copyWith(fontSize: 14),
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/btn_location.png',
                                  width: 40,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Kirim Review',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              height: 72,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: lightGreyColor,
                              ),
                              child: TextField(
                                controller: reviewController,
                                autofocus: false,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: greyTextStyle,
                                  hintText: 'Type Review .....',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                OutlinedButton(
                                  child: Text('Kirim'),
                                  style: OutlinedButton.styleFrom(
                                    primary: greenColor,
                                    backgroundColor: whiteColor,
                                    side:
                                        BorderSide(color: greenColor, width: 2),
                                  ),
                                  onPressed: () {
                                    if (reviewController.text == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'Kolom review belum diisi!'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      if (MyApp.isConnect) {
                                        setState(() {
                                          _restaurantApi = ApiService()
                                              .addReview(
                                                  widget.restaurant.id,
                                                  "Lazuardi",
                                                  reviewController.text);
                                          _restaurantApi = ApiService()
                                              .restaurantDetail(
                                                  id: widget.restaurant.id);
                                          reviewController.text = "";
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Periksa koneksi internet Anda!'),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      }
                                    }
                                    print("CONNECTIVITY : " +
                                        MyApp.isConnect.toString());
                                    print("SUBMIT REVIEW : " +
                                        reviewController.text);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Review',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: customerReviews.length,
                              itemBuilder: (context, index) {
                                var customerReview = customerReviews[index];
                                return ReviewList(
                                  name: customerReview.name,
                                  review: customerReview.review,
                                  date: customerReview.date,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
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
