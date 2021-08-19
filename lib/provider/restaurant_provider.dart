import 'package:flutter/material.dart';
import 'package:restoo/data/api/api_service.dart';
import 'package:restoo/data/models/restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  late RestaurantApi _restaurantApi;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantApi get result => _restaurantApi;
  ResultState get state => _state;

  Future<dynamic> searchRestaurantProvider({required String query}) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final searchApi = await apiService.searchRestaurant(query);
      if (searchApi.restaurants != null) {
        if (searchApi.restaurants!.isEmpty) {
          _state = ResultState.NoData;
          notifyListeners();
          return _message = 'Empty Data';
        } else {
          _state = ResultState.HasData;
          notifyListeners();
          print("HAS DATA PROVIDER");
          return _restaurantApi = searchApi;
        }
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> detailRestaurantProvider({required String id}) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detailApi = await apiService.restaurantDetail(id: id);
      if (detailApi.restaurant == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantApi = detailApi;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> addReviewRestaurantProvider(
      {required String id,
      required String name,
      required String review}) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final reviewApi = await apiService.addReview(id, name, review);
      if (reviewApi.error == false) {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantApi = reviewApi;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
