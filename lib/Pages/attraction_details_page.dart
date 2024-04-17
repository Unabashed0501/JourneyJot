import 'package:flutter/material.dart';
import 'package:my_tourist_app/Constants/map_consts.dart';

class AttractionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> attraction;

  AttractionDetailsPage({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attraction['Name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(attraction['Photo'] == ""
                ? MapConstants.defaultImageURL
                : attraction['Photo'] ?? attraction['Photo']),
            SizedBox(height: 16.0),
            Text(
              'Address:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Address']),
            SizedBox(height: 16.0),
            Text(
              'Brief Descriptions:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['HostWords']),
            SizedBox(height: 16.0),
            Text(
              'TEL:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Tel']),
            SizedBox(height: 16.0),
            Text(
              'Website:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Url'] ?? '暫無網址'),
          ],
        ),
      ),
    );
  }
}
