import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tehine/shared/style.dart';

import '../../providers/general_providers.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  const CalendarWidget({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  ConsumerState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  late DateTime focusedDate =
      ref.read(selectedEnglishDateProvider.notifier).state;

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      JewishDate jewishDate = JewishDate();
      jewishDate.setDate(day);
      ref.read(selectedHebrewDateProvider.notifier).state =
          jewishDate.toString();
      ref.read(selectedHebrewMonthDateProvider.notifier).state = ref
          .read(selectedHebrewDateProvider.notifier)
          .state
          .replaceAll(RegExp(r'[0-9\s]+'), '');
      this.focusedDate = focusedDay;
      ref.read(selectedEnglishDateProvider.notifier).state = focusedDay;
      ref.read(selectedDateProvider.notifier).state = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    JewishDate jewishDate = JewishDate();
    HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
    String hebrewDate = hebrewDateFormatter.format(jewishDate);
    String hebrewDay = jewishDate.getJewishDayOfMonth().toString();
    String hebrewMonth = jewishDate.toString();

    JewishDate convertToHebrewDate(DateTime gregorianDate) {
      JewishDate jewishDate = JewishDate.fromDateTime(gregorianDate);
      return jewishDate;
    }

    print('selected date should not be null ${ref.read(selectedDateProvider)}');
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Color(0xFFF5F5F5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
              rowHeight: 60,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.grey[850]),
                  weekdayStyle: TextStyle(color: Colors.grey[850])),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                leftChevronIcon:
                    Icon(Icons.arrow_back_ios, color: Colors.grey[850]),
                rightChevronIcon:
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[850]),
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, focusedDate),
              focusedDay: ref.watch(selectedEnglishDateProvider.notifier).state,
              calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: Colors.grey[850]),
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[850],
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFE6D3B3),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.grey[850]),
                  selectedDecoration: BoxDecoration(
                    color: Colors.grey[850],
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Color(0xFFF5F5F5))),
              firstDay: DateTime.utc(2023, 07, 7),
              lastDay: DateTime.utc(2033, 07, 7),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) {
                  var gregorianDate = date;

                  var jewishDate = convertToHebrewDate(gregorianDate);
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewMonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${jewishDate.getGregorianDayOfMonth()}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[850]),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          (jewishDate.getJewishDayOfMonth() == 1)
                              ? '${hebrewMonth.toString()}'
                              : '${jewishDate.getJewishDayOfMonth()}',
                          style:
                              TextStyle(fontSize: 8, color: Colors.grey[850]),
                        ),
                      ),
                    ],
                  );
                },
                selectedBuilder: (context, date, events) {
                  var gregorianDate = date;
                  var jewishDate = convertToHebrewDate(gregorianDate);
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewMonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: darkGrey,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(fontSize: 16, color: creamWhite),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            (jewishDate.getJewishDayOfMonth() == 1)
                                ? '${hebrewMonth.toString()}'
                                : '${jewishDate.getJewishDayOfMonth()}',
                            style: TextStyle(
                              fontSize: 8,
                              color: creamWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, date, events) {
                  var gregorianDate = date;
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewMonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 9.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: lightGrey,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${gregorianDate.day}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[850]),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            (jewishDate.getJewishDayOfMonth() == 1)
                                ? '${hebrewMonth.toString()}'
                                : '${jewishDate.getJewishDayOfMonth()}',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                headerTitleBuilder: (context, date) {
                  String monthName = DateFormat('MMMM').format(date);
                  var jewishdate2 = date;
                  var jewishDate1 = convertToHebrewDate(jewishdate2);
                  String hebrewmonthconvert = jewishDate1.toString();
                  hebrewMonth =
                      hebrewmonthconvert.replaceAll(RegExp(r'[0-9]'), '');

                  return Center(
                    child: Text(
                      '${monthName} -${hebrewMonth.toString()}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850]),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
