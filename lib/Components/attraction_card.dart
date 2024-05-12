import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_tourist_app/Components/like_button.dart';
import 'package:my_tourist_app/Components/modal_content.dart';
import 'package:my_tourist_app/Pages/attraction_details_page.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Redux/actions.dart';

class AttractionCard extends StatefulWidget {
  final dynamic attraction;
  final List<String> likes;
  final String itineraryName;
  final int numberOfDays;
  const AttractionCard({
    super.key,
    required this.attraction,
    required this.likes,
    required this.itineraryName,
    required this.numberOfDays,
  });

  @override
  State<AttractionCard> createState() => _AttractionCardState();
}

class _AttractionCardState extends State<AttractionCard> {
  late bool isLiked = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    StoreConnector<List<CartModel>, ViewModel>(
      converter: (store) => ViewModel.create(store),
      builder: (context, model) {
        // setState(() {
          isLiked = model.cartItems.any((item) =>
              item.isNotEmpty() && item.name == widget.attraction['Name']);
        // });
        return Container(); // Return a placeholder widget as StoreConnector needs to return a widget.
      },
    );
    // });
  }

  // toggle like button
  void toggleLikeButton() {
    setState(() {
      isLiked = !isLiked;
      print("toggleLikeButton");
      print(isLiked);
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
          trailing: StoreConnector<List<CartModel>, ViewModel>(
            converter: (store) => ViewModel.create(store),
            builder: (context, model) {
              print(model.cartItems);
              return LikeButton(
                isLiked: isLiked,
                day: model.cartItems
                    .firstWhere(
                        (item) => item.name == widget.attraction['Name'],
                        orElse: () => CartModel(day: 0))
                    .day,
                onTap: () {
                  toggleLikeButton();
                  if (isLiked) {
                    // Show modal bottom sheet
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
                          itineraryName: widget.itineraryName,
                        );
                      },
                    );
                  } else {
                    model.onItemRemoved(widget.attraction['Name']);
                  }
                },
              );
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
