import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoo/data/models/restaurant.dart';

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantApi> restaurantList() async {
    final response = await http.get(Uri.parse(_baseUrl + "list"));

    if (response.statusCode == 200) {
      return RestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<RestaurantApi> restaurantDetail({required String id}) async {
    final response = await http.get(Uri.parse(_baseUrl + "detail/" + id));

    if (response.statusCode == 200) {
      return RestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail restaurant');
    }
  }

  Future<RestaurantApi> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + "search?q=" + query));

    if (response.statusCode == 200) {
      return RestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurant');
    }
  }

  Future<RestaurantApi> addReview(
      String id, String name, String review) async {
    final response = await http.post(
      Uri.parse(_baseUrl + "review"),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded ',
        'X-Auth-Token': '12345',
      },
      body: {
        "id": id,
        "name": name,
        "review": review,
      },
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      return RestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }
}
