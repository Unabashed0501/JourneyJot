import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/like_button.dart';
import 'package:my_tourist_app/Components/modal_content.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Constants/map_consts.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:provider/provider.dart';

class SpecialCard extends StatefulWidget {
  final Map<String, dynamic> attraction;
  final String itineraryName;
  final int numberOfDays;
  const SpecialCard(
      {super.key,
      required this.attraction,
      required this.itineraryName,
      required this.numberOfDays});

  @override
  State<SpecialCard> createState() => _SpecialCardState();
}

class _SpecialCardState extends State<SpecialCard> {
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    isLiked = Provider.of<CartModel>(context, listen: false).cartItems.isEmpty
        ? false
        : Provider.of<CartModel>(context, listen: false).cartItems.any((item) =>
            item.isNotEmpty && item['Name'] == widget.attraction['Name']);
  }

  // toggle like button
  void toggleLikeButton() {
    setState(() {
      isLiked = !isLiked;
    });
  }

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
                  text: widget.attraction['Name'] ?? '',
                  size: 22.5,
                  fontColor: const Color.fromARGB(255, 189, 189, 189),
                ),
                const SizedBox(height: 5),
                SmallText(
                  text: widget.attraction['Address'] ?? 'aaaa',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                        tag: "home_to_info",
                        child: GetImageData(itinerary: widget.attraction)),
                  ),
                ),
                const SizedBox(height: 10),
                LikeButton(
                  isLiked: isLiked,
                  day: Provider.of<CartModel>(context, listen: false)
                      .cartItems
                      .firstWhere(
                          (item) => item['Name'] == widget.attraction['Name'],
                          orElse: () => {'Day': 0})['Day'],
                  onTap: () {
                    toggleLikeButton();
                    if (isLiked) {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          // Get the list of itinerary days and daily plans
                          List<String> itineraryDays = List.generate(
                            widget.numberOfDays,
                            (index) => 'Day ${index + 1}',
                          );
                          List<String> dailyPlans = List.generate(
                            widget.numberOfDays,
                            (index) => 'Plan ${index + 1}',
                          );

                          return ModalContent(
                              itineraryDays: itineraryDays,
                              dailyPlans: dailyPlans,
                              attraction: widget.attraction,
                              itineraryName: widget.itineraryName);
                        },
                      );
                    } else {
                      Provider.of<CartModel>(context, listen: false)
                          .removeItemFromCart(
                        widget.attraction['Name'],
                      );
                    }
                  },
                ),
              ],
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
          fallbackHeight: 200, 
          color: Colors.grey, 
        );
      },
    );
  }
}
