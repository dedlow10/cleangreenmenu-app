import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';
import '../models/menu.dart';

class RestaurantService {
  static const API_BASE_URL = "https://u9hmfgy0tc.execute-api.us-east-1.amazonaws.com/development";
   Future<Restaurant> getRestaurantById(String id) async {
    var result = await http.get(API_BASE_URL + "/restaurant/" + id);
    var restaurant = Restaurant.fromJson(jsonDecode(Utf8Decoder().convert(result.bodyBytes)));
    return restaurant;
  }

  Future<Menu> getRestaurantMenuById(String id) async {
      var result = await http.get(API_BASE_URL + "/restaurant/" + id + "/menu");
      var menu = Menu.fromJson(jsonDecode(Utf8Decoder().convert(result.bodyBytes)));
      return menu;
  }

    Future<List<Restaurant>> findRestaurantByName(String name) async {
      var result = await http.get(API_BASE_URL + "/restaurant/search?name=" + name);
      var restaurants = new List<Restaurant>();
      var results = jsonDecode(result.body);
      for (var result in  results) {
        restaurants.add(Restaurant.fromJson(result));
      }
      return restaurants;
  }
}