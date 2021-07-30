// import 'package:flutter_api_test/fetch_data/state_manager.dart';
// import 'dart:html';

import 'package:flutter/material.dart';
// import 'package:flutter_api_test/grid_photo.dart';
// import 'package:flutter_api_test/network_request.dart';
// import 'package:flutter_api_test/state_manager.dart';
import 'package:flutter_api_test/tab.dart';
// import 'package:provider/provider.dart';

// import 'network_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:freezed/builder.dart';
// import 'model/user.dart';
// import 'user_profile.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
  // runApp(ProviderScope(child: Gridphoto()));
}

// userProfile
// final axisCounters = <int>[3, 4, 5, 6, 7];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabView(),
    );
  }
}

// int selectAxis = 3;

// final gridMaxJudgeProvider = StateProvider((ref) => true);
// final gridMinJudgeProvider = StateProvider((ref) => true);
// final selectAxisProvider = StateProvider((ref) => 3);
// final selectIndexProvider = StateProvider((ref) => 0);

// class Gridphoto extends ConsumerWidget {
//   Object? get users => null;

//   List userData = [];

//   get length => null;

//   @override
//   Widget build(BuildContext context,
//       T Function<T>(ProviderBase<Object, T> provider) watch) {
//     AsyncValue<List<User>> users = watch(userStateFuture);
//     // final page = watch(pageProvider).state;
//     final ScrollController _scrollController = new ScrollController();
//     _scrollController.addListener(() async {
//       if (_scrollController.position.maxScrollExtent <=
//           _scrollController.position.pixels) {
//         // await context.refresh(userStateFuture);
//         context.read(countGridProvider).state = userData.length;
//       }
//     });
// // final gridJudgeProvider = StateProvider((ref) => )
//     final selectIndex = watch(selectIndexProvider).state;
//     final gridMaxJudge = watch(gridMaxJudgeProvider).state;
//     final gridMinJudge = watch(gridMinJudgeProvider).state;
//     final selectAxis = watch(selectAxisProvider).state;

//     void indexCounter(int index) {
//       context.read(selectIndexProvider).state = index;
//     }

//     // late int countGrid = watch(countGridProvider).state;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GridView'),
//         actions: <Widget>[
//           IconButton(
//             onPressed: !gridMaxJudge
//                 ? null
//                 : () {
//                     ++context.read(selectAxisProvider).state;
//                     context.read(gridMinJudgeProvider).state = true;
//                     if (selectAxis == 9) {
//                       context.read(gridMaxJudgeProvider).state = false;
//                     }
//                   },
//             icon: Icon(Icons.add),
//           ),
//           IconButton(
//             onPressed: !gridMinJudge
//                 // ignore: dead_code
//                 ? null
//                 : () {
//                     --context.read(selectAxisProvider).state;
//                     context.read(gridMaxJudgeProvider).state = true;
//                     if (selectAxis == 2) {
//                       context.read(gridMinJudgeProvider).state = false;
//                     }
//                   },
//             icon: Icon(Icons.remove),
//           )
//         ],
//       ),
//       body: users.when(
//         data: (value) {
//           listIn() {
//             context.refresh(userStateFuture);

//             for (int i = 0; i < value.length; i++) {
//               Map<userTitles, dynamic> userProfile = {
//                 userTitles.Name: value[i].name?.fullname ?? 'None',
//                 userTitles.Birthday: value[i].dob?.birthday ?? 'None',
//                 userTitles.Country: value[i].location?.country ?? 'None',
//                 userTitles.Phone: value[i].phone ?? 'None',
//                 userTitles.Password: value[i].login?.password ?? 'None',
//                 userTitles.Picture: value[i].picture?.large ?? 'None'
//               };
//               userData.add(userProfile);
//             }
//             countPage++;
//           }

//           listIn();

//           Widget userGrid(int index) => Center(
//                 child: RefreshIndicator(
//                   child: GridView.builder(
//                     controller: _scrollController,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: selectAxis,
//                     ),
//                     itemCount: userData.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (index == userData.length) {
//                         listIn();
//                       }
//                       return GestureDetector(
//                           onTap: () {
//                             context.read(countProvider).state = userTitles.Name;

//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         UserProfile(userData, index)));
//                           },
//                           child: Widget_photoItem(
//                               userData[index][userTitles.Picture]));
//                     },
//                   ),
//                   onRefresh: () async {
//                     await context.refresh(userStateFuture);
//                     userData = [];
//                     listIn();
//                   },
//                 ),
//               );

//           List<Widget> userGrids = [userGrid(0), userGrid(1), userGrid(2)];
//           return userGrids[selectIndex];
//         },
//         loading: () => const Center(
//           child: CircularProgressIndicator(),
//         ),
//         error: (error, stackTrace) => Center(
//           child: Text('${error.toString()}'),
//         ),
//       ),
//     );
//   }

//   // Future<void> reload(BuildContext context) async {}
// }

// // load() {
// //   return Container(
// //     child: CircularProgressIndicator(),
// //   );
// // }

// Widget_photoItem(dynamic pictureKey) {
//   return Container(
//     constraints: BoxConstraints.expand(),
//     child: Image.network(
//       pictureKey,
//       fit: BoxFit.contain,
//     ),
//   );
// }
