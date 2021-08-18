import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/data/models/restaurant.dart';
import 'package:restoo/pages/detail_page.dart';
import 'package:restoo/widgets/rating_star.dart';

class RestaurantList extends StatelessWidget {
  final BuildContext context;
  final Restaurant restaurant;

  const RestaurantList({
    Key? key,
    required this.context,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPage.routeName,
            arguments: restaurant,
          );
        },
        child: Row(
          children: [
            Hero(
              tag: restaurant.id,
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                imageUrl: "https://restaurant-api.dicoding.dev/images/small/" + restaurant.pictureId,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  padding: EdgeInsetsDirectional.all(10),
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 225,
                  child: Text(
                    restaurant.name,
                    style: blackTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      child: Icon(Icons.place_outlined),
                    ),
                    Text(
                      restaurant.city,
                      style: greyTextStyle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            RatingStar(rate: restaurant.rating),
          ],
        ),
      ),
    );
  }
}
