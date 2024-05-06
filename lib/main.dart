import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/Itinerary_planning_page.dart';
import 'package:my_tourist_app/Pages/attractions_page.dart';
import 'package:my_tourist_app/Pages/detailed_planning_page.dart';
import 'package:my_tourist_app/Theme/app_theme.dart';
import 'package:my_tourist_app/Pages/map_home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CartModel(),
        child: GetMaterialApp(
          title: 'My Line Tourist App',
          // theme: AppTheme.themeData(false, context),
          // home: const MyHomePage(title: 'Flutter Map Home Page'),
          initialRoute: ItineraryPlanningPage.id,
          routes: {
            ItineraryPlanningPage.id: (context) => ItineraryPlanningPage(),           
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
