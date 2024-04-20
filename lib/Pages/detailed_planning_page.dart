import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/reorderable_list_tile.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/attractions_page.dart';
import 'package:my_tourist_app/Pages/itinerary_planning_page.dart';
import 'package:my_tourist_app/Pages/map_home_page.dart';
import 'package:my_tourist_app/Theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class DetailedPlanningPage extends StatefulWidget {
  final String itineraryName;
  final DateTime selectedDate;
  final DateTime selectedEndDate;
  static String id = 'detailedPlanningPage';
  DetailedPlanningPage(
      {required this.itineraryName,
      required this.selectedDate,
      required this.selectedEndDate});

  @override
  State<DetailedPlanningPage> createState() => _DetailedPlanningPageState();
}

class _DetailedPlanningPageState extends State<DetailedPlanningPage> {
  List<TabData> generateTabs(int numberOfTabs) {
    List<TabData> tabs = [];
    for (int i = 1; i <= numberOfTabs; i++) {
      tabs.add(
        TabData(
          index: i,
          title: Tab(
            child: Text('Day $i'),
          ),
          content: Center(child: Text('Content for Tab $i')),
        ),
      );
    }
    return tabs;
  }

  int calculateDaysDifference(DateTime startDate, DateTime endDate) {
    DateTime start =
        DateTime.utc(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime.utc(endDate.year, endDate.month, endDate.day);

    int differenceInMilliseconds =
        end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    int differenceInDays =
        (differenceInMilliseconds / (1000 * 60 * 60 * 24)).round();

    return differenceInDays.abs();
  }

  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        child: Text('Day 1'),
      ),
      content: const Center(child: Text('Content for Tab 1')),
    ),
  ];
  int daysDifference = 0;

  @override
  void initState() {
    super.initState();
    daysDifference = calculateDaysDifference(widget.selectedDate, widget.selectedEndDate);
    tabs = generateTabs(daysDifference+1);
  }

  ReorderableListView buildCartItems(
      BuildContext context, List<dynamic> cartItems) {
    final Color oddItemColor = Colors.lime.shade100;
    final Color evenItemColor = Colors.deepPurple.shade100;
    final List<Card> cards = <Card>[
      for (int index = 0; index < cartItems.length; index += 1)
        Card(
          key: ValueKey(index),
          color: index.isOdd ? oddItemColor : evenItemColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 80,
              child: Center(
                child: BigText(text: '${cartItems[index]['Name']}', size: 15),
              ),
            ),
          ),
        ),
    ];

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(1, 6, animValue)!;
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            // Create a Card based on the color and the content of the dragged one
            // and set its elevation to the animated value.
            child: Card(
              elevation: elevation,
              color: cards[index].color,
              child: cards[index].child,
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      proxyDecorator: proxyDecorator,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = cartItems.removeAt(oldIndex);
          cartItems.insert(newIndex, item);
        });
      },
      children: cards,
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ItineraryPlanningPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const BigText(text: 'Scheduling...'),
          backgroundColor: AppTheme.appBarColor,
        ),
        body: Consumer<CartModel>(builder: (context, value, child) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            List filteredCartItemsByItinerary =
                Provider.of<CartModel>(context, listen: false)
                    .filterCartItemsByItinerary(widget.itineraryName);
            for (var day = 1; day <= tabs.length; day++) {
              List<dynamic> filteredCartItemsByDay =
                  filteredCartItemsByItinerary
                      .where((item) => item['Day'] == day)
                      .toList();
              updateTab(filteredCartItemsByDay, day);
            }
          });
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Expanded(
                  child: DynamicTabBarWidget(
                    dynamicTabs: tabs,
                    onTabControllerUpdated: (controller) {},
                    onTabChanged: (index) {},
                    onAddTabMoveTo: MoveToTab.last,
                    isScrollable: true,
                  ),
                ),
              ]);
        }),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          distance: 70,
          children: [
            FloatingActionButton(
              onPressed: () {
                addTab();
              },
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              // shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => AttractionsPage(
                          likes: ['123'],
                          itineraryName: widget.itineraryName,
                          numberOfDays: daysDifference,
                        ))));
              },
            ),
            FloatingActionButton(
              // shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.map_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) =>
                        MapHomePage(itineraryName: widget.itineraryName, numberOfDays: daysDifference))));
              },
            ),
            FloatingActionButton(
              // shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.close),
              onPressed: () {
                removeTab(0);
              },
            ),
          ],
        ));
  }

  void addTab() {
    setState(() {
      var tabNumber = tabs.length + 1;
      tabs.add(
        TabData(
          index: tabNumber,
          title: Tab(
            child: Text('Day $tabNumber'),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Dynamic Tab $tabNumber'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => removeTab(tabNumber - 1),
                child: const Text('Remove this Tab'),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.yellow.shade200)),
              ),
            ],
          ),
        ),
      );
    });
  }

  void removeTab(int id) {
    setState(() {
      tabs.removeAt(id);
    });
  }

  void updateTab(List<dynamic> cartItems, int day) {
    setState(() {
      int index = day - 1;
      if (cartItems.isEmpty) {
        tabs[index] = TabData(
            index: index,
            title: Tab(
              child: Text('Day $day'),
            ),
            content: const Center(
                child: SmallText(text: 'No itinerary yet ...', size: 15)));
      } else {
        tabs[index] = TabData(
          index: index,
          title: Tab(
            child: Text('Day $day'),
          ),
          content: buildCartItems(context, cartItems),
        );
      }
    });
  }
}
