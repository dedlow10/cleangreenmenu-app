import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/menu.dart';
import '../theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  Widget appBarTitleText = Text("Loading...");
  final scrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  var _futureMenu;
  _RestaurantScreenState(restaurantId) {
    this.restaurantId = restaurantId;
  }

  @override
  void initState() {
    super.initState();
    var restaurantService = new RestaurantService();
    restaurantService.getRestaurantById(this.restaurantId).then((val) {
      setState(() {
        if (val != null && val.name != null && val.name != "")
          appBarTitleText = Text(val.name);
        else {
          appBarTitleText = Text("Not Found...");
        }
      });
    });

    if (_futureMenu == null) _futureMenu = restaurantService.getRestaurantMenuById(this.restaurantId);
  }

  buildMenu(snapshot) {
    var list = ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        itemCount: snapshot.data.menuData["MenuSections"].length,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (BuildContext context, int index) {
          var menuSection = snapshot.data.menuData["MenuSections"][index];

          var menuItems = new List<Container>();
          for (var item in menuSection["MenuItems"]) {
            var nameContainer = Container(
                child: Text(
                  item["Name"],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
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
                  item["Description"] != null && item["Description"] != ""
                      ? descriptionContainer
                      : Container(),
                  item["Price"] != null ? priceContainer : Container()
                ]),
                width: 250));
          }

          return DefaultTextStyle(
              style: TextStyle(inherit: true, color: TextColor),
              child: Container(
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
        });

    return SliverFillRemaining(child: list);
  }

  _itemSelected(index) {
    scrollController.jumpTo(index: index);
  }

  buildNavigation(snapshot) {
    return Container(
        height: 35,
        child: ListView.builder(
            itemCount: snapshot.data.menuData["MenuSections"].length,
            itemBuilder: (BuildContext context, int index) {
              var menuSection = snapshot.data.menuData["MenuSections"][index];
              return Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: RaisedButton(
                      onPressed: () {},
                      color: ButtonColor,
                      child: GestureDetector(
                          onTap: () => _itemSelected(index),
                          child: Container(
                            child: Center(
                                child: Text(menuSection["SectionName"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          ))));
            },
            // This next line does the trick.
            scrollDirection: Axis.horizontal));
    //children: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appBarTitleText, backgroundColor: AppBarColor),
        body: FutureBuilder<Menu>(
            future: _futureMenu,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container(child: Text("Loading...", style: TextStyle(fontSize: 30))));
              }
              if (snapshot.data != null) {
                return CustomScrollView(slivers: [
                  SliverAppBar(
                      title: buildNavigation(snapshot),
                      pinned: true,
                      backgroundColor: ToolbarColor,
                      automaticallyImplyLeading: false),
                  buildMenu(snapshot)
                ]);
              } else {
                return Center(
                    child: Container(
                        child: Text(
                            "Oops, we couldn't find the restaurant you were looking for.",
                            style: TextStyle(fontSize: 20)),
                        width: 300));
              }
            }));
  }
}
