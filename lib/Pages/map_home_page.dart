import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/loading.dart';
import 'package:my_tourist_app/Map/map_location.dart';
import 'package:my_tourist_app/Pages/map_page.dart';
import 'package:my_tourist_app/Map/process_attractions.dart';

class MapHomePage extends StatelessWidget {
  const MapHomePage({super.key});
  static String id = 'home_page';

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
            );
          } else {
            print("not done");
            print(snapshot.connectionState);
            print(snapshot.data);
            return const Loading();
          }
        });
  }
}

class LoadAllData extends StatelessWidget {
  final LatLng currentPosition;
  const LoadAllData({
    super.key,
    required this.currentPosition,
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
            );
          } else {
            return const Loading();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.currentPosition});
  final String title;
  final LatLng currentPosition;
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
    currentWidget =
        MapPage(country: 'Taiwan', currentPosition: currentPosition);
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
        refSearchLocation: const LatLng(25.034724, 121.565175),
      ),
    );
  }
}
