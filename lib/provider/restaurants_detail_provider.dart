import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurants_detail.dart';
import 'package:restaurant_app/utils/request_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  RestaurantsDetail? _restaurantsDetail;
  RequestState? _state = RequestState.Empty;
  String _message = '';

  String get message => _message;
  RestaurantsDetail? get result => _restaurantsDetail;
  RequestState? get state => _state;

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = RequestState.Loading;
      notifyListeners();

      final restoDetail = await apiService.detailRestaurant(id);
      _state = RequestState.HasData;
      notifyListeners();
      return _restaurantsDetail = restoDetail;
    } catch (e) {
      _state = RequestState.Error;
      notifyListeners();
    }
  }
}
