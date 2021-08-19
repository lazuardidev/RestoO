import 'dart:convert';

RestaurantApi restaurantApiFromJson(String str) =>
    RestaurantApi.fromJson(json.decode(str));

String restaurantApiToJson(RestaurantApi data) => json.encode(data.toJson());

class RestaurantApi {
  bool error;
  String message;
  int? count;
  int? founded;
  Restaurant? restaurant;
  List<Restaurant>? restaurants;
  List<CustomerReview>? customerReviews;

  RestaurantApi({
    required this.error,
    required this.message,
    this.count,
    this.founded,
    this.restaurant,
    this.restaurants,
    this.customerReviews,
  });

  factory RestaurantApi.fromJson(Map<String, dynamic> json) => RestaurantApi(
        error: json["error"],
        message: json["message"] != null ? json["message"] : "",
        count: json["count"] ?? 0,
        founded: json["founded"] ?? 0,
        restaurant: json["restaurant"] != null
            ? Restaurant.fromJson(json["restaurant"])
            : null,
        restaurants: json["restaurants"] != null
            ? List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x)))
            : [],
        customerReviews: json["customerReviews"] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count ?? "",
        "founded": founded ?? "",
        "restaurant": restaurant?.toJson() ?? "",
        "restaurants": restaurants != null
            ? List<dynamic>.from(restaurants!.map((x) => x.toJson()))
            : "",
        "customerReviews": customerReviews != null
            ? List<dynamic>.from(customerReviews!.map((x) => x.toJson()))
            : "",
      };
}

class Restaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"] ?? "",
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"] ?? "",
        pictureId: json["pictureId"],
        categories: json["categories"] != null
            ? List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)))
            : [],
        menus: json["menus"] != null
            ? Menus.fromJson(json["menus"])
            : new Menus(foods: [], drinks: []),
        rating: json["rating"].toDouble(),
        customerReviews: json["customerReviews"] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "rating": rating,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  List<Category> foods;
  List<Category> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods:
            List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
        drinks: List<Category>.from(
            json["drinks"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}
