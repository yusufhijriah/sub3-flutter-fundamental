import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
// import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/data/model/restaurants_detail.dart';
import 'package:restaurant_app/data/model/searching_restaurant.dart';

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  http.Client client;

  ApiService(this.client);
  Logger _logger = Logger();

  Future<List<Restaurant>> listRestaurant() async {
    final response = await client.get(Uri.parse(_baseUrl + 'list'));
    if (response.statusCode == 200) {
      return Restaurants.fromJson(json.decode(response.body)).restaurants;
    } else {
      throw Exception('List Restaurants failed to load');
    }
  }

  Future<RestaurantsDetail> detailRestaurant(String id) async {
    final response = await client.get(Uri.parse(_baseUrl + 'detail/' + id));
    _logger.d(response.body);
    if (response.statusCode == 200) {
      return RestaurantsDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Detail Restaurants failed to load');
    }
  }

  Future<SearchRestaurant> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + 'search?q=$query'));
    _logger.d(response.body);
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data search restaurant');
    }
  }
}
