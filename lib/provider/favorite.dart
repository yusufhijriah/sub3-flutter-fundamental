import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurants.dart';

class FavoriteNotifer extends ChangeNotifier {
  List<Restaurant> _favorite = [];

  List<Restaurant> get favorite => _favorite;

  set favorite(List<Restaurant> favorite) {
    _favorite = favorite;
    notifyListeners();
  }

  setRestaurant(Restaurant restaurant) {
    if (!isfavorite(restaurant)) {
      _favorite.add(restaurant);
    } else {
      _favorite.removeWhere((element) => element.id == restaurant.id);
    }
    notifyListeners();
  }

  isfavorite(Restaurant restaurant) {
    var index = _favorite.indexWhere((element) => element.id == restaurant.id);

    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }
}
