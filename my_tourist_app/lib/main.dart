import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tourist_app/Pages/Itinerary_planning_page.dart';
import 'package:my_tourist_app/Pages/attractions_page.dart';
import 'package:my_tourist_app/Theme/app_theme.dart';
import 'package:my_tourist_app/Pages/home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Line Tourist App',
      theme: AppTheme.themeData(false, context),
      // home: const MyHomePage(title: 'Flutter Map Home Page'),
      initialRoute: CheckCurrentPosition.id,
      routes: {
        // MenuBook.id: (context) => const MenuBook(),
        // HomeScreen.id: (context) => const HomeScreen(),
        AttractionsPage.id: (context) => const AttractionsPage(),
        ItineraryPlanningPage.id: (context) => ItineraryPlanningPage(),
        // MyHomePage.id: (context) => const MyHomePage(title: 'Flutter Map Home Page'),
        // SignUpScreen.id: (context) => const SignUpScreen(),
        CheckCurrentPosition.id: (context) => const CheckCurrentPosition(),
      },
      debugShowCheckedModeBanner: false,
    );
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