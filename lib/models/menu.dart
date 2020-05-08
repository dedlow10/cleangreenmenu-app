import 'dart:collection';

class Menu {
  int id;
  String name;
  int restaurantId;
  LinkedHashMap<String, dynamic> menuData;
  DateTime createdOn;

  Menu({this.id, this.name, this.restaurantId, this.menuData, this.createdOn});

  factory Menu.fromJson(Map<String, dynamic> json) {
    if (json == null || json["message"] != null) return null;
    return Menu(
      id: json['Id'],
      name: json['Name'],
      restaurantId: json['RestaurantId'],
      menuData: json["MenuData"],
      createdOn: DateTime.parse(json["CreatedOn"])
    );
  }
}