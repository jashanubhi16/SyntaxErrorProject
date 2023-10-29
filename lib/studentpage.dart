import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:convert';

double x = 80, y = 100;

class WebApp extends StatelessWidget {
  const WebApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      routes: {
        "/home": (ctx) => WebTestOsm(),
      },
    );
  }
}

class WebTestOsm extends StatefulWidget {
  const WebTestOsm({super.key});
  @override
  State<StatefulWidget> createState() => _WebTestOsmState();
}

class _WebTestOsmState extends State<WebTestOsm> with OSMMixinObserver {
  late final MapController controller = MapController(
    // initPosition: GeoPoint(
    //   latitude: 44.01753206961715,
    //   longitude: 42.868008613586426,
    // )
    initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ),
  );
  final Key key = GlobalKey();

  ValueNotifier<bool> activateCollectGetGeoPointsToDraw = ValueNotifier(false);
  ValueNotifier<bool> activateDrawRoad = ValueNotifier(false);

  ValueNotifier<List<GeoPoint>> roadPoints = ValueNotifier([]);
  ValueNotifier<bool> isTracking = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller.addObserver(this);
    controller.listenerMapSingleTapping.addListener(onMapSingleTap);

    controller.listenerRegionIsChanging.addListener(() {
      var response = fetchAlbum();
      print(response);
      if (controller.listenerRegionIsChanging.value != null) {
        print("${controller.listenerRegionIsChanging.value}");
      }
    });
  }

  String xc = 'hexx', yc = 'heyy';

  Future<http.Response> fetchAlbum() async {
    print(xc + " " + yc);
    var response =
        await (http.get(Uri.parse("https://auto-app.onrender.com/user")));
    if (response.statusCode == 200) {
      print("Response Received");
      print(response.body);
    } else {
      print("sed");
    }
    var jsonData = response.body;
    final parsedJson = jsonDecode(jsonData);
    xc = parsedJson['x'];
    yc = parsedJson['y'];
    print(xc + " , " + yc);
    // yc = response.body
    print(xc);
    print("after await" + yc);
    x = double.parse(xc);
    y = double.parse(yc);
    return response;
  }

  void onMapSingleTap() async {
    if (controller.listenerMapSingleTapping.value != null) {
      final GeoPoint geoPoint = controller.listenerMapSingleTapping.value!;
      await controller.addMarker(
        geoPoint,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.push_pin),
        ),
      );
      if (activateCollectGetGeoPointsToDraw.value) {
        roadPoints.value = roadPoints.value..add(geoPoint);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Track Them!',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.currentLocation();
            },
            icon: Icon(Icons.location_history),
          ),
          IconButton(
            onPressed: () async {
              if (!activateCollectGetGeoPointsToDraw.value &&
                  roadPoints.value.isEmpty) {
                activateCollectGetGeoPointsToDraw.value = true;
              } else if (activateCollectGetGeoPointsToDraw.value &&
                  roadPoints.value.isNotEmpty) {
                await controller.drawRoad(
                  roadPoints.value.first,
                  roadPoints.value.last,
                  roadOption: RoadOption(
                    zoomInto: true,
                    roadColor: Colors.red,
                  ),
                );
                activateCollectGetGeoPointsToDraw.value = false;
                roadPoints.value = roadPoints.value..clear();
              }
            },
            icon: Icon(Icons.map_outlined),
          ),
          IconButton(
            onPressed: () async {
              if (isTracking.value) {
                await controller.disabledTracking();
              }
              if (!isTracking.value) {
                await controller.currentLocation();
                await controller.enableTracking();
              }
              isTracking.value = !isTracking.value;
            },
            icon: ValueListenableBuilder<bool>(
              valueListenable: isTracking,
              builder: (ctx, tracking, _) {
                return Icon(
                  tracking ? Icons.location_disabled : Icons.my_location,
                  color: tracking ? Colors.white : Colors.grey[400],
                );
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) {
          return OSMFlutter(
            key: key,
            controller: controller,
            osmOption: OSMOption(
              zoomOption: ZoomOption(
                initZoom: 5,
              ),
              markerOption: MarkerOption(
                defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.add_location,
                    color: Colors.amber,
                  ),
                ),
              ),
              staticPoints: [
                StaticPositionGeoPoint(
                  "line 1",
                  MarkerIcon(
                    icon: Icon(
                      Icons.train,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                  [
                    //GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
                    //GeoPoint(latitude: 47.4317782, longitude: 8.4716146),
                  ],
                ),
                // StaticPositionGeoPoint(
                //   "line 2",
                //   null,
                //   [
                //     GeoPoint(
                //       latitude: 44.01753206961715,
                //       longitude: 42.868008613586426,
                //     )
                //   ],
                // )
              ],
              showContributorBadgeForOSM: true,
            ),
            onGeoPointClicked: (geoPoint) async {
              if (geoPoint ==
                  GeoPoint(latitude: 47.442475, longitude: 8.4680389)) {
                await controller.setMarkerIcon(
                  geoPoint,
                  MarkerIcon(
                    icon: Icon(
                      Icons.bus_alert,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                );
              }
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(
                  geoPoint.toString(),
                ),
                action: SnackBarAction(
                  label: "hide",
                  onPressed: () {
                    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                  },
                ),
              ));
            },
            mapIsLoading: Center(
              child: Text("map is Loading"),
            ),
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.map_sharp),
      //     label: 'Map',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.person),
      //     label: 'Profile',
      //   ),
      // ]),
    );
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await controller.currentLocation();
      // await controller.changeLocation(
      //   GeoPoint(
      //     latitude: 47.433358,
      //     longitude: 168.4690184,
      //   ),
      // );
      // await controller.changeLocation(
      //   GeoPoint(MapController.withUserPosition(
      //   trackUserLocation: UserTrackingOption(
      //   enableTracking: true,
      //   unFollowUser: false,
      // )
      // )
      // )
      // );

      //await (UserTrackingOption ? controller.initMapWithUserPosition : '');

      await controller.setZoom(zoomLevel: 14);
      Future.delayed(Duration(seconds: 5), () {
        controller.changeLocation(GeoPoint(latitude: x, longitude: y));
      });

      double zoom = await controller.getZoom();
      print("zoom:$zoom");
      await controller.addMarker(
        GeoPoint(latitude: 47.442475, longitude: 8.4680389),
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.car_repair,
            color: Colors.black45,
            size: 48,
          ),
        ),
      );
      // await controller.setMarkerOfStaticPoint(
      //   id: "line 2",
      //   markerIcon: MarkerIcon(
      //     icon: Icon(
      //       Icons.train,
      //       color: Colors.orange,
      //       size: 48,
      //     ),
      //   ),
      // );

      await controller.setStaticPosition(
        [
          GeoPointWithOrientation(
            latitude: 47.4433594,
            longitude: 8.4680184,
            angle: pi / 4,
          ),
          GeoPointWithOrientation(
            latitude: 47.4517782,
            longitude: 8.4716146,
            angle: pi / 2,
          ),
        ],
        "line 2",
      );
    }
  }
}
