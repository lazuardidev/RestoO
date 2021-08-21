import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/main.dart';
import 'package:restoo/pages/home_page.dart';
import 'package:restoo/provider/restaurant_provider.dart';
import 'package:restoo/widgets/rating_star.dart';
import 'package:restoo/widgets/review_list.dart';

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
  TextEditingController _reviewController = TextEditingController(text: "");

  List<Category> _category = [];
  List<Category> _foods = [];
  List<Category> _drinks = [];
  List<CustomerReview> _customerReviews = [];

  List<String> _categoryList = [];
  List<String> _foodList = [];
  List<String> _drinkList = [];

  @override
  void dispose() {
    super.dispose();
    _reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) => WillPopScope(
        onWillPop: () async {
          if (MyApp.isConnect) {
            state.searchRestaurantProvider(query: '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Periksa koneksi internet Anda!'),
              duration: const Duration(seconds: 1),
            ));
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: (MyApp.isConnect == true)
              ? _buildDetailPage(context)
              : Center(
                  child: Image.asset('assets/vector/no_connection.jpg'),
                ),
        ),
      ),
    );
  }

  _getFoods(var list) {
    _foodList.clear();
    for (int i = 0; i < list.length; i++) {
      _foodList.add(list[i].name);
    }
  }

  _getDrinks(var list) {
    _drinkList.clear();
    for (int i = 0; i < list.length; i++) {
      _drinkList.add(list[i].name);
    }
  }

  _getCategory(var list) {
    _categoryList.clear();
    for (int i = 0; i < list.length; i++) {
      _categoryList.add(list[i].name);
    }
  }

  Widget _buildDetailPage(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(
            child: LottieBuilder.asset('assets/loading_animation.json'),
          );
        } else if (state.state == ResultState.HasData &&
            state.result.restaurant != null) {
          _category = state.result.restaurant!.categories;
          _foods = state.result.restaurant!.menus.foods;
          _drinks = state.result.restaurant!.menus.drinks;
          _customerReviews = state.result.restaurant!.customerReviews;

          _getCategory(_category);
          _getFoods(_foods);
          _getDrinks(_drinks);

          return Stack(
            children: [
              Hero(
                tag: state.result.restaurant!.id,
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: 300,
                  imageUrl:
                      "https://restaurant-api.dicoding.dev/images/medium/" +
                          state.result.restaurant!.pictureId,
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
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 24),
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            state.searchRestaurantProvider(query: '');
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
                                    width:
                                        MediaQuery.of(context).size.width - 134,
                                    child: Text(
                                      state.result.restaurant!.name,
                                      style:
                                          blackTextStyle.copyWith(fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  RatingStar(
                                      rate: state.result.restaurant!.rating),
                                ],
                              ),
                              GestureDetector(
                                child: Image.asset(
                                  (state.result.restaurant!.rating > 4)
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
                            state.result.restaurant!.description,
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
                              '${_categoryList.join(', ')}.',
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
                              '${_foodList.join(', ')}.',
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
                              '${_drinkList.join(', ')}.',
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
                                width: MediaQuery.of(context).size.width - 90,
                                child: Text(
                                  '${state.result.restaurant!.city}\n${state.result.restaurant!.address}',
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
                              controller: _reviewController,
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
                                  side: BorderSide(color: greenColor, width: 2),
                                ),
                                onPressed: () {
                                  if (_reviewController.text == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Kolom review belum diisi!'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    if (MyApp.isConnect) {
                                      state.addReviewRestaurantProvider(
                                          id: state.result.restaurant!.id,
                                          name: "Lazuardi",
                                          review: _reviewController.text);

                                      state.detailRestaurantProvider(
                                          id: state.result.restaurant!.id);
                                      _reviewController.text = "";
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'Periksa koneksi internet Anda!'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
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
                            itemCount: _customerReviews.length,
                            itemBuilder: (context, index) {
                              var customerReview = _customerReviews[index];
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
    );
  }
}
