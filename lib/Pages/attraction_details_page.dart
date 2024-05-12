import 'package:flutter/material.dart';
import 'package:my_tourist_app/Constants/map_consts.dart';

class AttractionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> attraction;

  const AttractionDetailsPage({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attraction['Name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(attraction['Photo'] == ""
                ? MapConstants.defaultImageURL
                : attraction['Photo'] ?? attraction['Photo']),
            const SizedBox(height: 16.0),
            const Text(
              'Address:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Address']),
            const SizedBox(height: 16.0),
            const Text(
              'Brief Descriptions:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['HostWords']),
            const SizedBox(height: 16.0),
            const Text(
              'TEL:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Tel']),
            const SizedBox(height: 16.0),
            const Text(
              'Website:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(attraction['Url'] ?? 'URL Not Found'),
          ],
        ),
      ),
    );
  }
}
