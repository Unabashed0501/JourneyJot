import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:my_tourist_app/Map/calculate_distance.dart';

abstract class ProcessAttractions {
  static List<dynamic> attractions = [];
  static Future<void> fetchAttractions() async {
    // try {
    final response = await http.get(
      Uri.parse(
          'https://data.moa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelStayEn.aspx'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        'Content-Type': 'text/plain; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body).firstWhere((element) {
      //       return element['ID'] == 224;
      //     })['Photo'] ==
      //     "");
      print('fetch data works');
      // setState(() {
      attractions = jsonDecode(response.body);
      // });
    } else {
      throw Exception('Failed to load attractions');
    }
  }

  static List<int> sortStations(LatLng currentPosition) {
    List<int> argsort = [];
    for (int i = 0; i < attractions.length; i++) {
      argsort.add(i);
    }
    argsort.sort((a, b) => CalculateDistance.calculateDistance(
            currentPosition,
            LatLng(double.parse(attractions[a]["Latitude"]),
                double.parse(attractions[a]["Longitude"])))
        .compareTo(CalculateDistance.calculateDistance(
            currentPosition,
            LatLng(double.parse(attractions[b]["Latitude"]),
                double.parse(attractions[b]["Longitude"])))));
    // currentStation = attractions[argsort[0]];
    return argsort;
  }
}
