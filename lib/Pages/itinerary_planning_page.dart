import 'package:flutter/material.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Pages/detailed_planning_page.dart';
import 'package:my_tourist_app/Components/special_card.dart';

class ItineraryPlanningPage extends StatefulWidget {
  @override
  _ItineraryPlanningPageState createState() => _ItineraryPlanningPageState();
  static String id = 'ItineraryPlanningPage';
}

class _ItineraryPlanningPageState extends State<ItineraryPlanningPage> {
  List<Map<String, dynamic>> itinerary = [];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: '我的行程'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              // background color
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.yellow.shade200),
              ),
              onPressed: () {
                _showCreateItineraryDialog(context);
              },
              child: const SmallText(text: '建立新行程'),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: itinerary.length,
                itemBuilder: (context, index) {
                  final day = itinerary[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailedPlanningPage(
                                itineraryName: itinerary[index]['name'],
                                selectedDate: itinerary[index]['date'],
                              ),
                            ),
                          );},
                          child:
                          SpecialCard(
                            itinerary: {
                              'name': itinerary[index]['name'] ?? "Test",
                              'date':
                                  'Day ${index + 1}: ${day['date'].toString()}',
                            },
                          ),
                        ),
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemCount: day['attractions'].length,
                      //   itemBuilder: (context, index) {
                      //     final attraction = day['attractions'][index];
                      //     return ListTile(
                      //       title: Text(attraction['Name']),
                      //       subtitle: Text(attraction['Address']),
                      //       // 可以在這裡實現點擊景點後的操作，如查看詳細資訊、編輯行程等
                      //     );
                      //   },
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String selectedDateString = '';
  Future<void> _showCreateItineraryDialog(BuildContext context) async {
    String itineraryName = '';

    return showModalBottomSheet(
      context: context,
      // radius: 10.0,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SmallText(
                    text: '建立新行程',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 48.0), // 空白間距，保持布局一致
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: '行程名稱'),
                onChanged: (value) {
                  itineraryName = value;
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: SmallText(
                  text: '選擇日期',
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
              ),
              SizedBox(height: 20),
              SmallText(text: selectedDateString),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    itinerary.add({
                      'name': itineraryName,
                      'date': selectedDate,
                      'attractions': [],
                    });
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => (DetailedPlanningPage(
                          itineraryName: itineraryName,
                          selectedDate: selectedDate)),
                    ),
                  );
                },
                // add background color
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.yellow.shade200),
                ),
                child: const SmallText(text: '確定'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedDateString = pickedDate.toString();
      });
      // itinerary.add({
      //   'name': itineraryName,
      //   'date': pickedDate,
      //   'attractions': [],
      // });
    }
    print(selectedDate);
    print(pickedDate.toString());
  }
}
