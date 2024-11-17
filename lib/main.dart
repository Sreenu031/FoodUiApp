import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

var bannerItems = ["Burger", "Cheese Chilly", "Noodles", "Pizza"];
var bannerImages = [
  "images/burger.jpg",
  "images/cheesechilly.jpg",
  "images/noodles.jpg",
  "images/pizza.jpg"
];

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> createList() async {
      List<Widget> items = [];
      String dataString =
          await DefaultAssetBundle.of(context).loadString("assets/data.json");
      List<dynamic> dataJson = jsonDecode(dataString);
      dataJson.forEach((object) {
        String finalString = "";
        List<dynamic> dataList = object["placeItems"];
        dataList.forEach((item) {
          finalString = finalString + item + " | ";
        });
        items.add(Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2.0,
                    blurRadius: 5.0,
                  )
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  child: Image.asset(
                    object['placeImage'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(object["placeName"]),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, bottom: 2.0),
                        child: Text(
                          finalString,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.black54),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        "Min. Order:${object['minOrder']}",
                        style: TextStyle(fontSize: 12.0, color: Colors.black54),
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
      });
      return items;
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                  Text("Foodies",
                      style: TextStyle(fontSize: 40, fontFamily: "Samantha")),
                  IconButton(onPressed: () {}, icon: Icon(Icons.person))
                ],
              ),
            ),
            BanneerWidgetArea(),
            Expanded(
              child: Container(
                child: FutureBuilder(
                    initialData: <Widget>[Text("")],
                    future: createList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: snapshot.data ?? [],
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black87,
        child: Icon(
          Icons.food_bank,
          color: Colors.white,
        ),
        shape: CircleBorder(),
      ),
    );
  }
}

class BanneerWidgetArea extends StatelessWidget {
  const BanneerWidgetArea({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);

    List<Widget> banners = [];
    for (int x = 0; x < bannerItems.length; x++) {
      var bannerView = Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  bannerImages[x],
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay for text visibility
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.9)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ]),
                ),
              ),
              // Banner text
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bannerItems[x],
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    Text(
                      "More than 40% off",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }

    return Container(
      width: screenWidth,
      height: screenHeight * 0.3, // Adjust the height based on screen size
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,
      ),
    );
  }
}
