import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';
import '../models/menu.dart';

class RestaurantService {
  static const API_BASE_URL = "https://u9hmfgy0tc.execute-api.us-east-1.amazonaws.com/development";
   Future<Restaurant> getRestaurantById(String id) async {
    var result = await http.get(API_BASE_URL + "/restaurant/" + id);
    var restaurant = Restaurant.fromJson(jsonDecode(result.body));
    return restaurant;
  }

  Future<Menu> getRestaurantMenuById(String id) async {
      var result = await http.get(API_BASE_URL + "/restaurant/" + id + "/menu");
      var menu = Menu.fromJson(jsonDecode(result.body));
      return menu;
  }
}