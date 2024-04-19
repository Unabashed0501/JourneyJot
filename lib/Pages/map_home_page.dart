import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/loading.dart';
import 'package:my_tourist_app/Map/map_location.dart';
import 'package:my_tourist_app/Pages/map_page.dart';
import 'package:my_tourist_app/Map/process_attractions.dart';

class MapHomePage extends StatelessWidget {
  const MapHomePage(
      {super.key, required this.itineraryName, required this.numberOfDays});
  static String id = 'home_page';
  final String itineraryName;
  final int numberOfDays;

  // Check Current Position
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetCurrentLocation.handleCurrentPosition(context, "Taiwan"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            LatLng currentPosition = snapshot.data as LatLng;
            // print(currentPosition);
            print("load all data");
            return LoadAllData(
              currentPosition: currentPosition,
              itineraryName: itineraryName,
              numberOfDays: numberOfDays,
            );
          } else {
            print("not done");
            // print(snapshot.connectionState);
            // print(snapshot.data);
            return const Loading();
          }
        });
  }
}

class LoadAllData extends StatelessWidget {
  final LatLng currentPosition;
  final String itineraryName;
  final int numberOfDays;
  const LoadAllData({
    super.key,
    required this.currentPosition,
    required this.itineraryName,
    required this.numberOfDays,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          ProcessAttractions.fetchAttractions(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("done");
            return MyHomePage(
              currentPosition: currentPosition,
              title: "Tourist App",
              itineraryName: itineraryName,
              numberOfDays: numberOfDays,
            );
          } else {
            return const Loading();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.currentPosition,
      required this.itineraryName,
      required this.numberOfDays});
  final String title;
  final LatLng currentPosition;
  final String itineraryName;
  final int numberOfDays;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final String title;
  late final LatLng currentPosition;
  late Widget currentWidget;
  late final List<Map<String, dynamic>> locations;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    // locations = ProcessCities.citiesData;
    currentPosition = widget.currentPosition;
    currentWidget = MapPage(
      country: 'Taiwan',
      currentPosition: currentPosition,
      itineraryName: widget.itineraryName,
      numberOfDays: widget.numberOfDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: "Find attractions ~", size: 25),
      ),
      body: MapPage(
        country: 'Taiwan',
        currentPosition: currentPosition,
        refSearchLocation: currentPosition,
        itineraryName: widget.itineraryName,
        numberOfDays: widget.numberOfDays,
      ),
    );
  }
}
