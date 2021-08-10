import 'package:flutter/material.dart';
import 'package:flutter_api_test/grid_photo.dart';

// import 'package:flutter_api_test/main.dart';
// import 'package:flutter_api_test/network_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// import 'main.dart';
import 'model/user.dart';
import 'package:flutter_api_test/state_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// List photos = [];
int countPage = 1;
// int countGrid = photos.length;

// final photosProvider = ChangeNotifierProvider((ref) => photos);
GridPhoto userData = GridPhoto();
final countGridProvider = StateProvider((ref) => userData.length);
// final latitudeProvider = StateProvider((ref) => 0.0);
// final longitudeProvider = StateProvider((ref) => 0.0);
// final photosGridProvider = StateProvider((ref) => photos);

enum userTitles {
  Name,
  Birthday,
  Country,
  Phone,
  Password,
  Picture,
  Latitude,
  Longitude,
}

final countProvider = StateProvider((ref) => userTitles.Name);

// ignore: must_be_immutable
class UserProfile extends ConsumerWidget {
  MapView getLocation = MapView();

  Object? get users => null;

  UserProfile(this.profile, this.index);

  List profile;
  int index;

  // String _location = 'no data';

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    // ignore: unused_local_variable
    AsyncValue<List<User>> users = watch(userStateFuture);

    // final int num = 0;
    final count = watch(countProvider).state;
    // final countLatitude = watch(latitudeProvider).state;
    // final countLongitude = watch(longitudeProvider).state;
    String viewCount = count.toString();
    viewCount = viewCount.replaceAll('userTitles.', '');
    // Gridphoto userData = Gridphoto();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height + 100,
              child: PageView.builder(
                  controller: PageController(initialPage: index),
                  itemCount: userData.length,
                  itemBuilder: (context, i) {
                    late dynamic userText = profile[i][count];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    profile[i][userTitles.Picture]),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    MapView(
                                      latitude: profile[i][userTitles.Latitude],
                                      longitude: profile[i]
                                          [userTitles.Longitude],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        profile[i][userTitles.Latitude],
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        profile[i][userTitles.Longitude],
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(30),
                        // ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
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

class MapView extends StatefulWidget {
  // const MapView({ Key? key,}) : super(key: key);
  final String? latitude;
  final String? longitude;
  MapView({this.latitude, this.longitude});
  @override
  _MapViewState createState() =>
      _MapViewState(latitude: latitude, longitude: longitude);
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final String? latitude;
  final String? longitude;
  _MapViewState({this.latitude, this.longitude});

  double current_latitude = 0.0;
  double current_longitude = 0.0;

  late LatLng current = LatLng(current_latitude, current_longitude);
  MapController _mapController = MapController();

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    current_latitude = position.latitude;
    current_longitude = position.longitude;
    current = LatLng(current_latitude, current_longitude);
    // _mapController.move(LatLng(26.1691567, 127.6556057), 3.0);
  }

  void _animatedMapMove(LatLng destLocation) {
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    var controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      _mapController.move(
        LatLng(
          _latTween.evaluate(animation),
          _lngTween.evaluate(animation),
        ),
        5.0,
      );
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(
                double.parse(latitude ?? '0.0'),
                double.parse(longitude ?? '0.0'),
              ),
              zoom: 5.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: LatLng(
                      double.parse(latitude ?? '0.0'),
                      double.parse(longitude ?? '0.0'),
                    ),
                    builder: (ctx) => Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ),
                  Marker(
                    width: 50,
                    height: 50,
                    point: current,
                    builder: (ctx) => Icon(
                      Icons.location_pin,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async {
            await getLocation();
            _animatedMapMove(current);
          },
          icon: Icon(
            Icons.my_location,
          ),
        ),
      ],
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
