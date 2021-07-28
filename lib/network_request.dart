import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_api_test/model/user.dart';
import 'package:http/http.dart' as http;
import 'model/user.dart';
// import 'package:freezed/builder.dart';

List<User> parseUsers(String responseBody) {
  var list = json.decode(responseBody)['results'] as List;
  List<User> users = list.map((model) => User.fromJson(model)).toList();
  // users.addAll(users);
  return users;
}

Future<List<User>> fetchUsers(int page) async {
  final response = await http
      .get(Uri.parse("https://randomuser.me/api/?page=$page&results=30"));
  if (response.statusCode == 200) {
    return compute(parseUsers, response.body);
  } else {
    throw Exception('Can\'t get users');
  }
}
