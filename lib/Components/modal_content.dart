import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Redux/actions.dart';

class ModalContent extends StatelessWidget {
  final List<String> itineraryDays;
  final List<String> dailyPlans;
  final dynamic attraction;
  final String itineraryName;

  const ModalContent({
    Key? key,
    required this.itineraryDays,
    required this.dailyPlans,
    required this.attraction,
    required this.itineraryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SmallText(
            text: 'Add to which day',
            size: 20,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: itineraryDays.length,
              itemBuilder: (context, index) {
                return StoreConnector<List<CartModel>, ViewModel>(
                    converter: (store) => ViewModel.create(store),
                    builder: (context, ViewModel model) => ListTile(
                          title: Text(itineraryDays[index]),
                          subtitle: Text(dailyPlans[index]),
                          onTap: () {
                            model.onItemAdded(CartModel(
                              itinerary: itineraryName,
                              name: attraction['Name'],
                              address: attraction['Address'],
                              day: index + 1,
                            ));
                            Navigator.pop(context);
                          },
                        ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
