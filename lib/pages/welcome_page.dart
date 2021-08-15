import 'package:flutter/material.dart';
import 'package:restoo/common/styles.dart';
import 'package:restoo/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = '/welcome_page';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: Image.asset(
                "assets/vector/welcome.png",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Welcome !",
              style: blackTextStyle.copyWith(
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Let's take a look at our\nrecommendations restaurant for you",
              style: greyTextStyle.copyWith(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 210,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: greenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Explore Resto',
                  style: whiteTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
