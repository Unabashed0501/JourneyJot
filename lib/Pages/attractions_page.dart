import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tourist_app/Components/attraction_card.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:provider/provider.dart';

class AttractionsPage extends StatefulWidget {
  final List<String> likes;
  const AttractionsPage({super.key, required this.likes});
  static String id = 'attractions_page';
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  List<dynamic> attractions = [];
  List<dynamic> filteredAttractions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  void filterAttractions(String query) {
    setState(() {
      filteredAttractions = attractions
          .where((attraction) => attraction['Name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
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
      // print(jsonDecode(response.body).firstWhere((element) {
      //       return element['ID'] == 224;
      //     })['Photo'] ==
      //     "");
      setState(() {
        attractions = jsonDecode(response.body);
        filteredAttractions = attractions;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterAttractions(value);
              },
            ),
          ),
          Expanded(
            child: attractions.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<CartModel>(builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: filteredAttractions.length,
                      itemBuilder: (context, index) {
                        final attraction = filteredAttractions[index];
                        return AttractionCard(
                          attraction: attraction,
                          likes: widget.likes,
                        );
                      },
                    );
                  }),
          ),
        ],
      ),

      // ListTile(
      //   title: Text(attraction['Name']),
      //   subtitle: Text(attraction['OpenHours']),
      //   // show images to same size
      //   leading: Image.network(
      //     attraction['Photo'] == ""
      //         ? 'https://media.vietravel.com/images/NewsPicture/Alishan-National-Scenic-Area.jpg'
      //         : attraction['Photo'],
      //     width: 100,
      //     height: 100,
      //     fit: BoxFit.cover,
      //   ),
      //   onTap: () {
      //     // Navigate to attraction details page
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => AttractionDetailsPage(
      //           attraction: attraction,
      //         ),
      //       ),
      //     );
      //   },
      // );
    );
  }
}
