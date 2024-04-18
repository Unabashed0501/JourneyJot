import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Model/cart_model.dart';
import 'package:my_tourist_app/Pages/attractions_page.dart';
import 'package:my_tourist_app/Pages/map_home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

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

  Widget proxyDecorator(Widget child, int index, Animation<double> animation,
      List<dynamic> cartItems) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        final item = cartItems[index];
        return Transform.scale(
          scale: scale,
          // Create a Card based on the color and the content of the dragged one
          // and set its elevation to the animated value.
          child: Card(
            elevation: elevation,
            color: Colors.green.shade200,
            child: SizedBox(
              height: 80,
              child: Center(
                child: Text('${item['Name']}'),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }

  ReorderableListView buildCartItems(
      BuildContext context, List<dynamic> cartItems) {
    return ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        proxyDecorator: (child, index, animation) =>
            proxyDecorator(child, index, animation, cartItems),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final dynamic item = cartItems.removeAt(oldIndex);
            cartItems.insert(newIndex, item);
          });
        },
        children: cartItems.map<Widget>((item) {
          return ListTile(
            key: ValueKey(item['Name']),
            title: Text(
              item['Name'],
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '\$' + item['Address'],
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList());
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
            for (var day = 1; day <= tabs.length; day++) {
              List<dynamic> filteredCartItems =
                  value.cartItems.where((item) => item['Day'] == day).toList();
              updateTab(filteredCartItems, day);
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

  void updateTab(List<dynamic> cartItems, int day) {
    setState(() {
      // tabs = cartItems.map((item) {
      //   return TabData(
      //     index: cartItems.indexOf(item),
      //     title: const Tab(
      //       child: Text('Day 1'),
      //     ),
      //     content: item,
      //   );
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
      // Add more tabs as needed
    });
  }
}
