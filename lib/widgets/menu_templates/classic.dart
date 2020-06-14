import 'dart:convert' show utf8;
import 'dart:ui';

import 'package:cleangreenmenu/models/menu.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../theme.dart';

class ClassicMenu extends StatelessWidget {
  final Menu menu;
  final ItemScrollController scrollController;
  final ItemPositionsListener itemPositionsListener;

  const ClassicMenu(
      {this.menu, this.scrollController, this.itemPositionsListener});

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        itemCount: menu.menuData["MenuSections"].length,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (BuildContext context, int index) {
          var menuSection = menu.menuData["MenuSections"][index];

          var menuItems = new List<Container>();
          for (var item in menuSection["MenuItems"]) {
            var nameContainer = Container(
                child: Text(
                  item["Name"],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                margin: new EdgeInsets.only(bottom: 5.0));

            var descriptionContainer = Container();
            var priceContainer = Container();
            if (item["Description"] != null) {
              descriptionContainer = Container(
                  child: Text(item["Description"],
                      style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center),
                  margin: new EdgeInsets.only(bottom: 5.0));
            }

            if (item["Price"] != null) {
              priceContainer = Container(
                child: Text("\$" + item["Price"].toString(),
                    style: TextStyle(fontSize: 15)),
                margin: new EdgeInsets.only(bottom: 15.0));
            }

            menuItems.add(Container(
                child: Column(children: <Widget>[
                  nameContainer,
                  descriptionContainer,
                  priceContainer
                ]),
                width: 250));
          }

          return DefaultTextStyle(
              style: TextStyle(inherit: true, color: TextColor),
              child: Container(
                  margin: new EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(children: [
                    Text(menuSection["SectionName"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: TextColor)),
                    Container(
                      child: Column(children: menuItems),
                      margin: new EdgeInsets.only(bottom: 40.0, top: 5),
                    ),
                  ])));
        });
  }
}
