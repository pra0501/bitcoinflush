import 'package:flutter/material.dart';

import 'coins_page.dart';
import 'portfolio_page.dart';
import 'top_coin.dart';
import 'trendsPage.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 150.0),
      child: Drawer(
        child: Container(
          color: const Color(0xff151c19),
          child: ListView(
            // Remove padding
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/image/logo_hor.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Color(0xffc30508),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoinsPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/homepage.png"),
                        Spacer(),
                        Text("Home",textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TopGainer()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/up-arrow.png"),
                        Spacer(),
                        Text("Top Coins",textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PortfolioPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Shape.png"),
                        Spacer(),
                        Text("Portfolio",textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoinsPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Icon.png"),
                        Spacer(),
                        Text("Coins",textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrendsPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Rise.png"),
                        Spacer(),
                        Text("Trends",textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}