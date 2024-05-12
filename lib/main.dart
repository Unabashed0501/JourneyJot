import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/Itinerary_planning_page.dart';
import 'package:my_tourist_app/Redux/reducers.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'lib/.env');
  final store = Store<List<CartModel>>(cartReducer, initialState: [CartModel.initialState()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<List<CartModel>> store;
  const MyApp({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: GetMaterialApp(
          title: 'My Line Tourist App',
          initialRoute: ItineraryPlanningPage.id,
          routes: {
            ItineraryPlanningPage.id: (context) => const ItineraryPlanningPage(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
