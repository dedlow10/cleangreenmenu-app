import 'package:cleangreenmenu/widgets/menu_templates/classic.dart';
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
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
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

    if (_futureMenu == null)
      _futureMenu = restaurantService.getRestaurantMenuById(this.restaurantId);
  }

  buildMenu(snapshot) {
    return SliverFillRemaining(
        child: ClassicMenu(
            menu: snapshot.data,
            scrollController: scrollController,
            itemPositionsListener: itemPositionsListener));
  }

  buildNavigation(snapshot) {
    return SliverAppBar(
        title: Container(
            height: 40,
            child: ListView.builder(
                itemCount: snapshot.data.menuData["MenuSections"].length,
                itemBuilder: (BuildContext context, int index) {
                  var menuSection =
                      snapshot.data.menuData["MenuSections"][index];
                  return Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                          onPressed: () {
                            scrollController.jumpTo(index: index);
                          },
                          color: ButtonColor,
                          child: Container(
                            child: Center(
                                child: Text(menuSection["SectionName"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          )));
                },
                scrollDirection: Axis.horizontal)),
        pinned: true,
        backgroundColor: ToolbarColor,
        bottom: PreferredSize(
            child: Container(color: DividerColor, height: 2.0),
            preferredSize: Size.fromHeight(2.0)),
        automaticallyImplyLeading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitleText,
          backgroundColor: AppBarColor,
        ),
        body: FutureBuilder<Menu>(
            future: _futureMenu,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        child: Text("Loading...",
                            style: TextStyle(fontSize: 30))));
              }
              if (snapshot.data != null) {
                return CustomScrollView(slivers: [buildNavigation(snapshot), buildMenu(snapshot)]);
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
