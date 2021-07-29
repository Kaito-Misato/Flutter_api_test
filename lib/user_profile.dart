// import 'dart:ffi';
// import 'dart:js';

// import 'dart:js';

// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_api_test/main.dart';
// import 'package:flutter_api_test/network_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'main.dart';
import 'model/user.dart';
import 'package:flutter_api_test/state_manager.dart';

// List photos = [];
int countPage = 1;
// int countGrid = photos.length;

// final photosProvider = ChangeNotifierProvider((ref) => photos);
Gridphoto userData = Gridphoto();
final countGridProvider = StateProvider((ref) => userData.length);
// final photosGridProvider = StateProvider((ref) => photos);

enum userTitles { Name, Birthday, Country, Phone, Password, Picture }
final countProvider = StateProvider((ref) => userTitles.Name);

// ignore: must_be_immutable
class UserProfile extends ConsumerWidget {
  Object? get users => null;
  UserProfile(this.profile, this.index);
  List profile;
  int index;

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    // ignore: unused_local_variable
    AsyncValue<List<User>> users = watch(userStateFuture);

    // final int num = 0;
    final count = watch(countProvider).state;
    String viewCount = count.toString();
    viewCount = viewCount.replaceAll('userTitles.', '');
    // Gridphoto userData = Gridphoto();

    return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: Center(
          child: Align(
              alignment: Alignment.center,
              child: PageView.builder(
                  controller: PageController(initialPage: index),
                  itemCount: userData.length,
                  itemBuilder: (context, i) {
                    late dynamic userText = profile[i][count];
                    return Container(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(profile[i][userTitles.Picture]),
                        radius: 48,
                      ),
                      Text('$viewCount'),
                      Text(
                        '$userText',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read(countProvider).state =
                                  userTitles.Name;
                            },
                            icon: Icon(Icons.person_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read(countProvider).state =
                                  userTitles.Birthday;
                            },
                            icon: Icon(Icons.calendar_today_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read(countProvider).state =
                                  userTitles.Country;
                            },
                            icon: Icon(Icons.map_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read(countProvider).state =
                                  userTitles.Phone;
                            },
                            icon: Icon(Icons.phone),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read(countProvider).state =
                                  userTitles.Password;
                            },
                            icon: Icon(Icons.lock),
                          ),
                        ],
                      ),
                    ]));
                  })),
        )

        // Container(
        //   child: FloatingActionButton(
        //     child: Icon(Icons.autorenew),
        //     onPressed: () async {
        //       await context.refresh(userStateFuture);
        //       context.read(countProvider).state = userTitles.Name;
        //     },
        //   ),
        // ),
        );
  }
}
// class LoadPicture {
//   static listIn(dynamic pictureKey) {
//     photos.add(pictureKey);
//   }
// }

// nextGrid(List list) {
//   photos.addAll(list);
// }
// class NextPicture {
//   static nextGrid(List pictureKey) {
//     photos.addAll(pictureKey);
//   }
// }

// final pageProvider = StateProvider((ref) => 1);
