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
            // MenuBook.id: (context) => const MenuBook(),
            // HomeScreen.id: (context) => const HomeScreen(),
            // AttractionsPage.id: (context) => const AttractionsPage(likes:['123']),
            ItineraryPlanningPage.id: (context) => ItineraryPlanningPage(),
            // DetailedPlanningPage.id: (context) => DetailedPlanningPage(
            //     itineraryName: 'Taiwan', selectedDateString: '2022-12-12'),
            // MyHomePage.id: (context) => const MyHomePage(title: 'Flutter Map Home Page'),
            // SignUpScreen.id: (context) => const SignUpScreen(),
            // MapHomePage.id: (context) => const MapHomePage(),
          },
          debugShowCheckedModeBanner: false,
        ));
    // Widget build(BuildContext context) {
    //   return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //       useMaterial3: true,
    //     ),
    //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   );
    // }
  }
}
