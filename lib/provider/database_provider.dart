import 'package:flutter/material.dart';
import 'package:restaurant_app/data/helper/database_helper.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/utils/request_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  RequestState? _state = RequestState.Empty;
  RequestState get state => _state!;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.length > 0) {
      _state = RequestState.HasData;
    } else {
      _state = RequestState.NoData;
      _message = 'Restaurant Favorite Kamu\nBelum Ada';
    }
    notifyListeners();
  }

  Future<void> addFavorites(Restaurant restaurants) async {
    try {
      await databaseHelper.insertFavorite(restaurants);
      _getFavorites();
    } catch (e) {
      _state = RequestState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  Future<void> removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = RequestState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
