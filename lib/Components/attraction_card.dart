import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/like_button.dart';
import 'package:my_tourist_app/Components/modal_content.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/attraction_details_page.dart';
import 'package:provider/provider.dart';

class AttractionCard extends StatefulWidget {
  final dynamic attraction;
  final List<String> likes;
  final String itineraryName;
  final int numberOfDays;
  AttractionCard(
      {super.key,
      required this.attraction,
      required this.likes,
      required this.itineraryName, 
      required this.numberOfDays});

  @override
  State<AttractionCard> createState() => _AttractionCardState();
}

class _AttractionCardState extends State<AttractionCard> {
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    List filterCartItemsByItinerary =
        Provider.of<CartModel>(context, listen: false)
            .filterCartItemsByItinerary(widget.itineraryName);
    isLiked = filterCartItemsByItinerary.isEmpty
        ? false
        : filterCartItemsByItinerary.any((item) =>
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(widget.attraction['Name']),
          subtitle: Text(widget.attraction['Address']),
          // show images to same size
          leading: Image.network(
            widget.attraction['Photo'] == ""
                ? 'https://media.vietravel.com/images/NewsPicture/Alishan-National-Scenic-Area.jpg'
                : widget.attraction['Photo'],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          trailing: LikeButton(
            isLiked: isLiked,
            day: Provider.of<CartModel>(context, listen: false)
                .cartItems
                .firstWhere((item) => item['Name'] == widget.attraction['Name'],
                    orElse: () => {'Day': 0})['Day'],
            onTap: () {
              toggleLikeButton();
              (isLiked)
                  ? showModalBottomSheet<void>(
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
                          itineraryName: widget.itineraryName,
                        );
                      },
                    )
                  : Provider.of<CartModel>(context, listen: false)
                      .removeItemFromCart(widget.attraction['Name']);
            },
          ),
          onTap: () {
            // Navigate to attraction details page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AttractionDetailsPage(
                  attraction: widget.attraction,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
