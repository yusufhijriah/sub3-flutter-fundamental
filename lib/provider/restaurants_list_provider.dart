import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:restaurant_app/utils/request_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchRestaurantList();
  }

  List<Restaurant>? _restaurant;
  RequestState? _state;
  String _message = '';

  String get message => _message;

  List<Restaurant>? get result => _restaurant;

  RequestState? get state => _state;

  Future<dynamic> _fetchRestaurantList() async {
    try {
      _state = RequestState.Loading;
      notifyListeners();
      final restaurantList = await apiService.listRestaurant();
      if (restaurantList.isEmpty) {
        _state = RequestState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = RequestState.HasData;
        notifyListeners();
        return _restaurant = restaurantList;
      }
    } catch (e) {
      _state = RequestState.Error;
      notifyListeners();
      return _message = e.toString();
    }
  }
}
