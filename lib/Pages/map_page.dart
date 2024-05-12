import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
// import 'package:my_tourist_app/Pages/markers.dart';
import 'package:my_tourist_app/Constants/map_consts.dart';
import 'package:my_tourist_app/Map/map_data.dart';
import 'package:my_tourist_app/Map/map_location.dart';
import 'package:my_tourist_app/Map/process_attractions.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  final LatLng currentPosition;
  final LatLng? refSearchLocation;
  final String? country;
  final String itineraryName;
  final int numberOfDays;

  const MapPage({
    super.key,
    required this.currentPosition,
    this.refSearchLocation,
    this.country,
    required this.itineraryName,
    required this.numberOfDays,
  });
  // ignore: constant_identifier_names

  static String accessToken = dotenv.env['ACCESS_TOKEN']!;
  static String mapStyleId = dotenv.env['MAP_STYLE_ID']!;
  // static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  static String id = "map_page";
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final PageController pageController;
  final MapController mapController = MapController();
  bool drawMapData = true;
  late int selectedIndex;
  late LatLng? refLocation;
  late List<int> argsort = [];
  late LatLng currentLocation;
  late List<Map<String, dynamic>> stations;
  late List<dynamic> attractions;
  late String? country;
  late Timer timerCurrentPosition;

  showLocation(idx) {
    if (drawMapData) {
      pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        drawMapData = true;
      });
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => pageController.animateToPage(
          idx,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  animateMap(idx) {
    _animatedMapMove(
      stations[idx]['location'] ?? MapConstants.myLocation,
      12,
    );
  }

  @override
  void initState() {
    super.initState();
    country = widget.country;
    currentLocation = widget.currentPosition;
    refLocation = widget.refSearchLocation;
    argsort = ProcessAttractions.sortStations(currentLocation);
    selectedIndex = argsort[0];
    pageController = PageController(
      initialPage: 0,
    );
    attractions = ProcessAttractions.attractions;
  }

  Future<LatLng> refreshLocation() async {
    return await GetCurrentLocation.handleCurrentPosition(
        context, country ?? "Taiwan");
  }

  @override
  void dispose() {
    pageController.dispose();
    mapController.dispose();
    super.dispose();
  }

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FlutterMap(
          mapController: mapController,
          options: MapOptions(
            minZoom: 4,
            maxZoom: 19,
            initialZoom: 12,
            initialCenter: refLocation ?? currentLocation,
            onTap: (_, point) {
              List<int> newArgSort = ProcessAttractions.sortStations(point);
              setState(() {
                refLocation = point;
                argsort = newArgSort;
                selectedIndex = argsort[0];
                drawMapData = true;
              });
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _animatedMapMove(point, 12);
              });
            },
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                setState(() {
                  drawMapData = false;
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/oscarfu0501/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
              additionalOptions: {
                'accessToken': MapPage.accessToken,
                // "pk.eyJ1Ijoib3NjYXJmdTA1MDEiLCJhIjoiY2xtbWM2NWJtMGl2bzJzdG51dmpsMHJobCJ9.1YNIStVXWlC9A1BA4Gs-PQ",
                'mapStyleId': MapPage.mapStyleId,
              },
            ),
            Stack(children: [
              MarkerLayer(
                markers: [
                  for (int i = 0; i < attractions.length; i++)
                    Marker(
                      width: 80,
                      height: 120,
                      point: LatLng(
                          double.parse(attractions[argsort[i]]["Latitude"]),
                          double.parse(attractions[argsort[i]]["Longitude"])),
                      child: GestureDetector(
                        onTap: () {
                          showLocation(i);
                          setState(() {
                            selectedIndex = argsort[i];
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: argsort[i] == selectedIndex ? 1 : 0.7,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: argsort[i] == selectedIndex ? 1 : 0.5,
                            child: Column(children: [
                              Text(
                                attractions[argsort[i]]["Name"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SvgPicture.asset(
                                'assets/icons/map_marker.svg',
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  Marker(
                    width: 30,
                    height: 30,
                    point: currentLocation,
                    child: Image.asset(
                      'assets/icons/current_position.png',
                    ),
                  ),
                ],
              ),
            ]),
          ]),
      Positioned(
        left: 0,
        right: 0,
        bottom: 2,
        height: MediaQuery.of(context).size.height * 0.3,
        child: drawMapData
            ? PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  _animatedMapMove(
                      LatLng(
                          double.parse(attractions[argsort[value]]["Latitude"]),
                          double.parse(
                              attractions[argsort[value]]["Longitude"])),
                      12);
                  setState(() {
                    selectedIndex = argsort[value];
                    drawMapData = true;
                  });
                },
                itemCount: attractions.length,
                itemBuilder: (_, index) {
                  return MapData(
                    attraction: attractions[argsort[index]],
                    currentPosition: currentLocation,
                    itineraryName: widget.itineraryName,
                    numberOfDays: widget.numberOfDays,
                    // store: widget.store,
                  );
                },
              )
            : const SizedBox.shrink(),
      ),
    ]);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
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
}
