import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/widgets/rating_star.dart';

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
  bool isFavorite = false;
  List<String> makananList = [];
  List<String> minumanList = [];

  @override
  void initState() {
    super.initState();
    getDataMakanan();
    getDataMinuman();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.restaurant.id,
            child: CachedNetworkImage(
              width: double.infinity,
              height: 300,
              imageUrl: widget.restaurant.pictureId,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
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
                        child: Image.asset('assets/icons/back_arrow_white.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 180),
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
                                width: MediaQuery.of(context).size.width - 134,
                                child: Text(
                                  widget.restaurant.name,
                                  style: blackTextStyle.copyWith(fontSize: 18),
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
                              setState(() {
                                isFavorite = !isFavorite;
                              });
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
                        'Makanan',
                        style: blackTextStyle.copyWith(fontSize: 14),
                      ),
                      Container(
                        child: Text(
                          '${makananList.join(', ')}.',
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
                          '${minumanList.join(', ')}.',
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
                              widget.restaurant.city,
                              style: greyTextStyle.copyWith(fontSize: 14),
                            ),
                          ),
                          Image.asset(
                            'assets/icons/btn_location.png',
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getDataMakanan() {
    for (int i = 0; i < widget.restaurant.menus.foods.length; i++) {
      makananList.add(widget.restaurant.menus.foods[i].name);
    }
  }

  getDataMinuman() {
    for (int i = 0; i < widget.restaurant.menus.drinks.length; i++) {
      minumanList.add(widget.restaurant.menus.drinks[i].name);
    }
  }
}
