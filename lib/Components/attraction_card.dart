import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/like_button.dart';
import 'package:my_tourist_app/Components/modal_content.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/attraction_details_page.dart';
import 'package:provider/provider.dart';

class AttractionCard extends StatefulWidget {
  final dynamic attraction;
  final List<String> likes;
  const AttractionCard(
      {super.key, required this.attraction, required this.likes});

  @override
  State<AttractionCard> createState() => _AttractionCardState();
}

class _AttractionCardState extends State<AttractionCard> {
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    // print("cartItems");
    // print(widget.attraction['Name']);
    print(Provider.of<CartModel>(context, listen: false).cartItems ?? '');
    isLiked = Provider.of<CartModel>(context, listen: false).cartItems.isEmpty
        ? false
        : Provider.of<CartModel>(context, listen: false).cartItems.any((item) =>
            item.isNotEmpty && item['Name'] == widget.attraction['Name']);
    // print('isLiked');
    // print(isLiked);
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
            onTap: () {
              toggleLikeButton();
              (isLiked)
                  ? showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        // Get the list of itinerary days and daily plans
                        final List<String> itineraryDays = [
                          'Day 1',
                          'Day 2',
                          'Day 3'
                        ]; // Assuming this is the list of itinerary days
                        final List<String> dailyPlans = [
                          'Plan 1',
                          'Plan 2',
                          'Plan 3'
                        ]; // Assuming this is the list of daily plans

                        return ModalContent(
                            itineraryDays: itineraryDays,
                            dailyPlans: dailyPlans,
                            attraction: widget.attraction);
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
