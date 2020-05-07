import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/menu.dart';
import '../theme.dart';

class RestaurantScreen extends StatefulWidget {
  String restaurantId;
  RestaurantScreen(restaurantId) {
    this.restaurantId = restaurantId;
  }

  @override
  _RestaurantScreenState createState() =>
      _RestaurantScreenState(this.restaurantId);
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  String restaurantId;
  String restaurantName;
  var appBarTitleText = new Text("");

  var _futureRestaurant;
  var _futureMenu;
  _RestaurantScreenState(restaurantId) {
    this.restaurantId = restaurantId;
  }

  @override
  void initState() {
    super.initState();
    var restaurantService = new RestaurantService();
    _futureRestaurant =
        restaurantService.getRestaurantById(this.restaurantId).then((val) {
      setState(() {
        if (val != null)
          appBarTitleText = Text(val.name);
        else {
          appBarTitleText = Text("Clean Green Menu");
        }
      });
    });

    _futureMenu = restaurantService.getRestaurantMenuById(this.restaurantId);
  }

  buildMenu(snapshot) {
    var list = new List<Container>();
    for (var menuSection in snapshot.data.menuData["MenuSections"]) {
      var menuItems = new List<Container>();
      for (var item in menuSection["MenuItems"]) {
        var nameContainer = Container(
            child: Text(item["Name"], style: TextStyle(fontSize: 20)),
            margin: new EdgeInsets.only(bottom: 5.0));
        var descriptionContainer = Container(
            child: Text(item["Description"],
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),
            margin: new EdgeInsets.only(bottom: 5.0));
        var priceContainer = Container(
            child: Text("\$" + item["Price"].toString(),
                style: TextStyle(fontSize: 15)),
            margin: new EdgeInsets.only(bottom: 15.0));
        menuItems.add(Container(
            child: Column(children: <Widget>[
              nameContainer,
              descriptionContainer,
              priceContainer
            ]),
            width: 250));
      }

      list.add(Container(
          margin: new EdgeInsets.only(top: 10),
          child: Column(children: [
            Text(menuSection["SectionName"],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: PrimaryColor)),
            Container(
              child: Column(children: menuItems),
              margin: new EdgeInsets.only(bottom: 20.0, top: 5),
            )
          ])));
    }
    return Center(child: ListView(children: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appBarTitleText, backgroundColor: PrimaryColor),
        body: FutureBuilder<Menu>(
            future: _futureMenu,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.data != null) {
                return buildMenu(snapshot);
              } else {
                return Center(child: Container(child: Text("Oops, we couldn't find the restaurant you were looking for.", style: TextStyle(fontSize: 20)), width: 300));
              }
            }));
  }
}
