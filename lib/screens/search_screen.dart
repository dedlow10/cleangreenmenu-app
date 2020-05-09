import 'package:cleangreenmenu/models/restaurant.dart';
import 'package:cleangreenmenu/screens/restaurant_screen.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Restaurant> list = new List<Restaurant>();
  Future<List<Restaurant>> search(String search) async {
    var restaurantService = new RestaurantService();
    return await restaurantService.findRestaurantByName(search);
  }

  buildSearchWidget() {
    return SearchBar<Restaurant>(
      hintText: "Find a restaurant",
      onSearch: search,
      minimumChars: 1,
      emptyWidget: ListTile(title: Text("No Results Found...")),
      onItemFound: (Restaurant restaurant, int index) {
        return GestureDetector(
          child: ListTile(title: Text(restaurant.name)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RestaurantScreen(restaurant.id.toString())));
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('images/logo.png',
              alignment: Alignment.centerLeft, height: 70, fit: BoxFit.cover),
          backgroundColor: AppBarColor,
        ),
        body: Container(
          child: buildSearchWidget(),
          margin: new EdgeInsets.symmetric(horizontal: 10.0),
        ));
  }
}
