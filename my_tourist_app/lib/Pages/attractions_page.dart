import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tourist_app/Pages/attraction_details_page.dart';

class AttractionsPage extends StatefulWidget {
  const AttractionsPage({super.key});
  static String id = 'attractions_page';
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  List<dynamic> attractions = [];

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  Future<void> fetchAttractions() async {
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
      print(jsonDecode(response.body).firstWhere((element) {
            return element['ID'] == 224;
          })['Photo'] ==
          "");
      setState(() {
        attractions = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load attractions');
    }
    // } catch (e) {
    //   print(e.toString());
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist Attractions'),
      ),
      body: attractions.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: attractions.length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return ListTile(
                  title: Text(attraction['Name']),
                  subtitle: Text(attraction['OpenHours']),
                  // show images to same size
                  leading: Image.network(
                    attraction['Photo'] == ""
                        ? 'https://media.vietravel.com/images/NewsPicture/Alishan-National-Scenic-Area.jpg'
                        : attraction['Photo'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    // Navigate to attraction details page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AttractionDetailsPage(
                          attraction: attraction,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
