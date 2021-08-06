import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';
// import 'package:freezed/builder.dart';
// import 'package:build_runner/build_runner.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    Name? name,
    Birthday? dob,
    Address? location,
    String? phone,
    Password? login,
    Picture? picture,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

class Password {
  late String password;
  Password({required this.password});
  Password.fromJson(Map json) {
    password = json['password'];
  }
  Map toJson() {
    final Map data = new Map();
    data['password'] = this.password;
    return data;
  }
}

class Coordinate {
  late String latitude;
  late String longitude;
  Coordinate({required this.latitude, required this.longitude});

  Coordinate.fromJson(Map json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  Map toJson() {
    final Map data = new Map();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Address {
  late String country;
  late Coordinate coordinates;

  Address({
    required this.country,
    required this.coordinates,
  });

  Address.fromJson(Map json) {
    country = json['country'];
    coordinates = Coordinate.fromJson(json['coordinates']);
  }
  Map toJson() {
    final Map data = new Map();
    data['country'] = this.country;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Birthday {
  late String birthday;
  Birthday({required this.birthday});
  Birthday.fromJson(Map json) {
    birthday = json['date'].substring(0, 10);
  }
  Map toJson() {
    final Map data = new Map();
    data['date'] = this.birthday;
    return data;
  }
}

class Name {
  // String title;
  late String first;
  late String last;
  late String fullname;

// this.title,
  Name({required this.first, required this.last, required this.fullname});

  Name.fromJson(Map json) {
    // title = json['title'];
    first = json['first'];
    last = json['last'];
    fullname = json['first'] + " " + json['last'];
  }

  Map toJson() {
    final Map data = new Map();
    // data['title'] = this.title;
    data['first'] = this.first;
    data['last'] = this.last;
    data['fullName'] = this.fullname;
    return data;
  }
}

class Picture {
  late String large;
  late String medium;
  late String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  Picture.fromJson(Map json) {
    large = json['large'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
  }

  Map toJson() {
    final Map data = new Map();
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
