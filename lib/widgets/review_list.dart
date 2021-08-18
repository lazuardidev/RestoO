import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';

class ReviewList extends StatelessWidget {
  final String name;
  final String review;
  final String date;

  const ReviewList({
    Key? key,
    required this.name,
    required this.review,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          child: Image.asset('assets/icons/profile.png'),
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
                name,
                style: blackTextStyle.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 225,
              child: Text(
                review,
                style: greyTextStyle.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          date,
          style: greyTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
