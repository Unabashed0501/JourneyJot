import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_tourist_app/Pages/attraction_details_page.dart';
import 'package:my_tourist_app/Components/special_card.dart';

class MapData extends StatefulWidget {
  const MapData(
      {super.key, required this.attraction, required this.currentPosition});
  final Map<String, dynamic> attraction;
  final LatLng currentPosition;

  @override
  State<MapData> createState() => _MapDataState();
}

class _MapDataState extends State<MapData> {
  late final Map<String, dynamic> attraction;
  late String country;

  @override
  void initState() {
    super.initState();
    attraction = widget.attraction;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AttractionDetailsPage(
                  attraction: attraction,
                ),
              ),
            );
          },
          child: SpecialCard(itinerary: attraction)),
    );
  }
}
