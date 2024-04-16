import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/special_card.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';

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
      body: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Expanded(
          child: DynamicTabBarWidget(
            dynamicTabs: tabs,
            onTabControllerUpdated: (controller) {},
            onTabChanged: (index) {},
            onAddTabMoveTo: MoveToTab.last,
            isScrollable: true,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTab();
          print(tabs);
          // setState(() {
          //   tabBarLength += 1; // Increment tabBarLength
          //   tabController = TabController(
          //       length: tabBarLength, vsync: this); // Update TabController
          // });
          // print(tabBarLength);
        },
        child: Icon(Icons.add),
      ),
    );
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
}
