import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/utils/calendar_util.dart' as date_util;

import '../../widgets/tiles/event_invitation_tile_widget.dart';

class InvitationsScreen extends ConsumerStatefulWidget {
  const InvitationsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<InvitationsScreen> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  // Widget backgroundView() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.background,
  //     ),
  //   );
  // }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            date_util.DateUtils.months[currentDateTime.month - 1] +
                ' ' +
                currentDateTime.year.toString(),
            style: TextStyle(
                color: Colors.grey[850],
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget hrizontalCapsuleListView() {
    return Container(
      width: width,
      height: 83,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            // color: Colors.grey[850] ?? Colors.grey,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (currentMonthList[index].day != currentDateTime.day)
                  ? Color(0xFFE6D3B3)
                  : Colors.grey[850] ?? Colors.grey,
              // color: Colors.grey[850] ?? Colors.grey,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: (currentMonthList[index].day != currentDateTime.day)
                    ? Color(0xFFE6D3B3)
                    : Colors.grey[850] ?? Colors.grey,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  currentMonthList[index].day.toString(),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? Colors.grey[850] // cream
                              : Color(0xFFF5F5F5)), // grey
                ),
                Text(
                  date_util
                      .DateUtils.weekdays[currentMonthList[index].weekday - 1],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? Colors.grey[850] // cream
                              : Color(0xFFF5F5F5)), // grey
                )
              ],
            ),
          ),
          // child: Container(
          //   // color: Colors.grey[850] ?? Colors.grey,
          //   width: 80,
          //   height: 80,
          //   decoration: BoxDecoration(
          //     color: (currentMonthList[index].day != currentDateTime.day)
          //         ? Colors.grey[850]
          //         : Color(0xFFE6D3B3),
          //     // color: Colors.grey[850] ?? Colors.grey,
          //     borderRadius: BorderRadius.circular(50),
          //     border: Border.all(
          //       color: (currentMonthList[index].day != currentDateTime.day)
          //           ? Colors.grey[850] ?? Colors.grey
          //           : Color(0xFFE6D3B3),
          //       width: 2.0,
          //     ),
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text(
          //         currentMonthList[index].day.toString(),
          //         style: TextStyle(
          //             fontSize: 25,
          //             fontWeight: FontWeight.bold,
          //             color:
          //                 (currentMonthList[index].day != currentDateTime.day)
          //                     ? Color(0xFFF5F5F5) // cream
          //                     : Colors.grey[850]), // grey
          //       ),
          //       Text(
          //         date_util
          //             .DateUtils.weekdays[currentMonthList[index].weekday - 1],
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //             color:
          //                 (currentMonthList[index].day != currentDateTime.day)
          //                     ? Color(0xFFF5F5F5) // cream
          //                     : Colors.grey[850]), // grey
          //       )
          //     ],
          //   ),
          // ),
        ));
  }

  Widget topView() {
    return Container(
      height: 150,

      // height * 0.25,
      width: width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          topView(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        selectedColor: Color(0xFFF5F5F5),
                        backgroundColor: Colors.grey[850],
                        label: Text(
                          'Today',
                          style: TextStyle(color: Color(0xFFF5F5F5)),
                        ),
                        selected:
                            false, // Set to true if you want it selected by default
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      SizedBox(width: 7),
                      ChoiceChip(
                        selectedColor: Colors.grey[850],
                        backgroundColor: Color(0xFFE6D3B3),
                        label: Text('All'),
                        selected: false,
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      // SizedBox(width: 7),
                      // ChoiceChip(
                      //   selectedColor: Colors.grey[850],
                      //   backgroundColor: Color(0xFFE6D3B3),
                      //   label: Text('Invitations'),
                      //   selected: false,
                      //   onSelected: (selected) {
                      //     // Handle chip selection
                      //   },
                      // ),
                      SizedBox(width: 7),
                      ChoiceChip(
                        selectedColor: Colors.grey[850],
                        backgroundColor: Color(0xFFE6D3B3),
                        label: Text('Going'),
                        selected: false,
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      SizedBox(width: 7),
                      ChoiceChip(
                        selectedColor: Colors.grey[850],
                        backgroundColor: Color(0xFFE6D3B3),
                        label: Text('expired'),
                        selected: false,
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      SizedBox(width: 7),
                      ChoiceChip(
                        selectedColor: Colors.grey[850],
                        backgroundColor: Color(0xFFE6D3B3),
                        label: Text('Upcoming'),
                        selected: false,
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      SizedBox(width: 7),
                      ChoiceChip(
                        selectedColor: Colors.grey[850],
                        backgroundColor: Color(0xFFE6D3B3),
                        label: Text('Not Going'),
                        selected: false,
                        onSelected: (selected) {
                          // Handle chip selection
                        },
                      ),
                      // Add more ChoiceChips as needed
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 5),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       ChoiceChip(
              //         selectedColor: Colors.grey[850],
              //         backgroundColor: Color(0xFFE6D3B3),
              //         label: Text('Weddings'),
              //         selected:
              //             false, // Set to true if you want it selected by default
              //         onSelected: (selected) {
              //           // Handle chip selection
              //         },
              //       ),
              //       SizedBox(width: 5),
              //       ChoiceChip(
              //         selectedColor: Color(0xFFF5F5F5),
              //         backgroundColor: Colors.grey[850],
              //         label: Text(
              //           "Bar Mitzvah's",
              //           style: TextStyle(color: Color(0xFFF5F5F5)),
              //         ),
              //         selected: false,
              //         onSelected: (selected) {
              //           // Handle chip selection
              //         },
              //       ),
              //       SizedBox(width: 5),
              //       ChoiceChip(
              //         selectedColor: Colors.grey[850],
              //         backgroundColor: Color(0xFFE6D3B3),
              //         label: Text('Engagements'),
              //         selected: false,
              //         onSelected: (selected) {
              //           // Handle chip selection
              //         },
              //       ),
              //       SizedBox(width: 5),
              //       ChoiceChip(
              //         selectedColor: Colors.grey[850],
              //         backgroundColor: Color(0xFFE6D3B3),
              //         label: Text("Bris Milah's"),
              //         selected: false,
              //         onSelected: (selected) {
              //           // Handle chip selection
              //         },
              //       ),
              //       // Add more ChoiceChips as needed
              //     ],
              //   ),
              // )
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // EventInvitationTileWidget(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
