import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Constants/map_consts.dart';

class SpecialCard extends StatelessWidget {
  final Map<String, dynamic> itinerary;
  const SpecialCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color.fromARGB(255, 42, 42, 42),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                BigText(
                  text: itinerary['Name'] ?? '',
                  size: 22.5,
                  fontColor: const Color.fromARGB(255, 189, 189, 189),
                ),
                const SizedBox(height: 5),
                SmallText(
                  text: itinerary['Address'] ?? 'aaaa',
                  fontColor: const Color.fromARGB(255, 189, 189, 189),
                ),
                const SizedBox(height: 10),
                // Row(
                //   children: [
                //     TagsWidget(
                //       icon: Icons.thermostat_auto_rounded,
                //       // iconBackgroundColor: Color.fromARGB(255, 42, 42, 42),
                //       tagName: station['temperature'].toString(),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                    tag: "home_to_info",
                    child: GetImageData(itinerary: itinerary)),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class GetImageData extends StatelessWidget {
  final Map<String, dynamic> itinerary;
  GetImageData({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    String imageURL = itinerary['Photo'] == ""
        ? MapConstants.defaultImageURL
        : itinerary['Photo'] ?? MapConstants.defaultImageURL;
    return Image.network(
      imageURL,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Placeholder(
          fallbackHeight: 200, // Placeholder 的高度
          color: Colors.grey, // 替代內容的顏色
        );
      },
    );
  }
}
