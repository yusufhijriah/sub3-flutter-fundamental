import 'package:restaurant_app/data/model/restaurants.dart';

class SearchRestaurant {
  final String error;
  final String founded;
  List<Restaurant> restaurants;

  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) {
    var resto = json['restaurants'] as List;
    List<Restaurant> restoSearch =
        resto.map((i) => Restaurant.fromJson(i)).toList();
    return SearchRestaurant(
        error: json['error'].toString(),
        founded: json['founded'].toString(),
        restaurants: restoSearch);
  }
}
