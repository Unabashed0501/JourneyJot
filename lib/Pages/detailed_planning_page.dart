import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_tourist_app/Map/map_location.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/attractions_page.dart';
import 'package:my_tourist_app/Pages/map_home_page.dart';
import 'package:my_tourist_app/Pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:geolocator/geolocator.dart';

class DetailedPlanningPage extends StatefulWidget {
  final String itineraryName;
  final DateTime selectedDate;

  DetailedPlanningPage(
      {required this.itineraryName, required this.selectedDate});

  @override
  State<DetailedPlanningPage> createState() => _DetailedPlanningPageState();
}

class _DetailedPlanningPageState extends State<DetailedPlanningPage> {
  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        child: Text('Day 1'),
      ),
      content: const Center(child: Text('Content for Tab 1')),
    ),
    // Add more tabs as needed
  ];
  // @override
  // void initState() {
  //   // Dispose of the previous TabController if it exists
  //   // if (tabController != null) {
  //   //   tabController.dispose();
  //   // }

  //   // Create TabController with initial tabBarLength
  //   tabController = TabController(length: tabBarLength, vsync: this);
  //   super.initState();
  // }
  List<Widget> buildCartItems(BuildContext context, List<dynamic> cartItems) {
    return cartItems.map((item) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              item[0],
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '\$' + item[1],
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('詳細行程規劃'),
          // bottom: TabBar(
          //   isScrollable: true,
          //   tabs: _buildTabBarItems(), // Build TabBar items based on tabBarLength
          //   controller: tabController,
          // ),
        ),
        body: Consumer<CartModel>(builder: (context, value, child) {
          print(value.cartItems);
          // updateTab(value.cartItems, 0);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            updateTab(value.cartItems, 0);
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
                print(tabs);
              },
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              // shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const AttractionsPage(
                          likes: ['123'],
                        ))));
              },
            ),
            FloatingActionButton(
              // shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.map_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const MapHomePage())));
              },
            ),
            // FloatingActionButton.small(
            //   // shape: const CircleBorder(),
            //   heroTag: null,
            //   child: const Icon(Icons.share),
            //   onPressed: () {
            // final state = _key.currentState;
            // if (state != null) {
            //   debugPrint('isOpen:${state.isOpen}');
            //   state.toggle();
            // }
            // },
            // ),
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

  void updateTab(List<dynamic> cartItems, int index) {
    setState(() {
      // tabs = cartItems.map((item) {
      //   return TabData(
      //     index: cartItems.indexOf(item),
      //     title: const Tab(
      //       child: Text('Day 1'),
      //     ),
      //     content: item,
      //   );
      int day = index + 1;
      tabs[index] = TabData(
          index: index,
          title: Tab(
            child: Text('Day $day'),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildCartItems(context, cartItems),
          ));

      // Add more tabs as needed
    });
  }
}
