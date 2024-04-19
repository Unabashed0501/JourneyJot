import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:my_tourist_app/Components/big_text.dart';
import 'package:my_tourist_app/Components/itinerary_card.dart';
import 'package:my_tourist_app/Components/small_text.dart';
import 'package:my_tourist_app/Pages/detailed_planning_page.dart';
import 'package:my_tourist_app/Theme/app_theme.dart';

class ItineraryPlanningPage extends StatefulWidget {
  @override
  _ItineraryPlanningPageState createState() => _ItineraryPlanningPageState();
  static String id = 'itineraryPlanningPage';
}

class _ItineraryPlanningPageState extends State<ItineraryPlanningPage> {
  List<Map<String, dynamic>> itinerary = [];
  late DateTime selectedDate;
  late DateTime selectedEndDate;
  late String selectedDateString;
  late String selectedEndDateString;
  bool isNameDuplicate = false;
  // DateTime time = DateTime(2024, 04, 19, 00, 35);
  // DateTime dateTime = DateTime(2024, 04, 19, 23, 45);

  @override
  void initState() {
    // date = DateTime(2024, 04, 19);
    selectedDate = DateTime.now();
    selectedEndDate = DateTime.now();
    selectedDateString =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    selectedEndDateString = selectedDateString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: 'My Itinerary'),
        backgroundColor: AppTheme.appBarColor,
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
              child: const SmallText(text: 'Create New Itinerary', size: 15),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailedPlanningPage(
                                    itineraryName: itinerary[index]['Name'],
                                    selectedDate: selectedDate,
                                    selectedEndDate: selectedEndDate,
                                  ),
                                ),
                              );
                            },
                            child: ItineraryCard(
                              itinerary: {
                                'Name': itinerary[index]['Name'] == ""
                                    ? "Test"
                                    : itinerary[index]['Name'],
                                'Date': (itinerary[index]['Date'] ==
                                        itinerary[index]['EndDate'])
                                    ? 'Date: ${itinerary[index]['Date']}'
                                    : 'Date: ${itinerary[index]['Date']}\nEnd Date: ${itinerary[index]['EndDate']}',
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showCreateItineraryDialog(BuildContext context) {
    String itineraryName = '';
    bool checkForDuplicateName(String newName) {
      for (var itineraryData in itinerary) {
        String existingName = itineraryData['Name'];
        if (newName == existingName) {
          return true;
        }
      }
      return false;
    }

    bool isValidDateTime(DateTime startDate, DateTime endDate) {
      if (startDate.compareTo(endDate) <= 0) {
        return true;
      }
      return false;
    }

    return showModalBottomSheet(
      context: context,
      // radius: 10.0,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
                // mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        text: 'Build New Itinerary',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(width: 48.0),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Itinerary Name',
                      errorText: isNameDuplicate ? 'Name already exists' : null,
                    ),
                    onChanged: (value) {
                      itineraryName = value;
                      isNameDuplicate = checkForDuplicateName(itineraryName);
                      print(isNameDuplicate);
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: <Widget>[
                      _DatePickerItem(
                        children: [
                          SmallText(
                            text: 'Start Date: ',
                            fontWeight: FontWeight.bold,
                            size: 20,
                          ),
                          CupertinoButton(
                            // Display a CupertinoDatePicker in date picker mode.
                            onPressed: () => _showDialog(
                              CupertinoDatePicker(
                                initialDateTime: selectedDate,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                minimumDate: DateTime(2000),
                                maximumDate: DateTime(2101),
                                use24hFormat: true,
                                // This shows day of week alongside day of month
                                showDayOfWeek: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (newDate) {
                                  print('change');
                                  print(newDate.toString());
                                  print(selectedDate.toString());
                                  setState(() {
                                    selectedDate = newDate;
                                    selectedDateString =
                                        '${newDate.year}-${newDate.month}-${newDate.day}';
                                  });
                                  print(selectedDate.day);
                                  print(selectedDateString);
                                },
                              ),
                            ),
                            child: BigText(
                              text: selectedDateString,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      _DatePickerItem(
                        children: [
                          const SmallText(
                            text: 'End Date: ',
                            fontWeight: FontWeight.bold,
                            size: 20,
                          ),
                          CupertinoButton(
                            // Display a CupertinoDatePicker in date picker mode.
                            onPressed: () => _showDialog(
                              CupertinoDatePicker(
                                initialDateTime: selectedEndDate,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                minimumDate: DateTime(2000),
                                maximumDate: DateTime(2101),
                                use24hFormat: true,
                                // This shows day of week alongside day of month
                                showDayOfWeek: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (newDate) {
                                  setState(() {
                                    selectedEndDate = newDate;
                                    selectedEndDateString =
                                        '${newDate.year}-${newDate.month}-${newDate.day}';
                                  });

                                  print(selectedEndDate.day);
                                  print(selectedEndDateString);
                                },
                              ),
                            ),
                            child: BigText(
                              text: selectedEndDateString,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      (isValidDateTime(selectedDate, selectedEndDate))
                          ? const SizedBox(height: 40)
                          : const SmallText(
                              text: 'Error Name or Date', fontColor: Colors.red),
                      ElevatedButton(
                        onPressed: isNameDuplicate ||
                                !isValidDateTime(selectedDate, selectedEndDate)
                            ? null
                            : () {
                                setState(() {
                                  itinerary.add({
                                    'Name': itineraryName,
                                    'Date': selectedDateString,
                                    'EndDate': selectedEndDateString,
                                    'Attractions': [],
                                  });
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => (DetailedPlanningPage(
                                      itineraryName: itineraryName,
                                      selectedDate: selectedDate,
                                      selectedEndDate: selectedEndDate,
                                    )),
                                  ),
                                );
                              },
                        // add background color
                        style: ButtonStyle(
                          backgroundColor: (isNameDuplicate ||
                                  !isValidDateTime(
                                      selectedDate, selectedEndDate))
                              ? WidgetStateProperty.all<Color>(Colors.red)
                              : WidgetStateProperty.all<Color>(
                                  AppTheme.buttonColor),
                        ),
                        child: const SmallText(text: 'Confirm'),
                      ),
                    ],
                  ),
                ]));
      },
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Create a button to pop the modal.
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // Create a container to hold the date picker.
              Expanded(child: child),
            ],
          ),
        ),
      ),
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
    // print(selectedDate);
    print(selectedDateString);
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
