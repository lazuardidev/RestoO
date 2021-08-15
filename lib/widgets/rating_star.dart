import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';

class RatingStar extends StatelessWidget {
  final double rate;

  const RatingStar({Key? key, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
            5,
            (index) => Icon(
              (index < rate) ? Icons.star : Icons.star_outline,
              size: 16,
              color: Colors.yellow[600],
            ),
          ) +
          [
            SizedBox(
              width: 4,
            ),
            Text(
              rate.toString(),
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
          ],
    );
  }
}
