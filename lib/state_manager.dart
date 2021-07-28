// import 'package:fetch_data/flutter_api_test/model/user.dart';
// import 'package:fetch_data/network_request.dart';
import 'package:flutter_api_test/user_profile.dart';
import 'package:flutter_api_test/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:freezed/builder.dart';
import 'network_request.dart';

final userStateFuture = FutureProvider<List<User>>((ref) async {
  return fetchUsers(countPage);
});
