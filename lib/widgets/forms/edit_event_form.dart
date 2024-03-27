import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tehine/shared/style.dart';

import '../../backend/api/events/airtable/upload_events.dart';
import '../../backend/api/events/shared_preferences/save_event_to_shared_preferences.dart';
import '../../models/country_model.dart';
import '../../models/event_model.dart';
import '../../providers/event_providers.dart';
import '../../providers/general_providers.dart';
import '../../providers/user_providers.dart';
import '../bottom_sheet_widgets/calendar_widget.dart';
import '../bottom_sheet_widgets/country_state_picker/select_country_widget.dart';
import '../bottom_sheet_widgets/country_state_picker/select_state_widget.dart';

// This needs refactoring should make one class for the fields.

class EditEventForm extends ConsumerStatefulWidget {
  // final EventModel event;
  final void Function(String) onSave;
  const EditEventForm(
      {required this.onSave,
      // required this.event,
      Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _EditEventFormState();
}

class _EditEventFormState extends ConsumerState<EditEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String eventName = widget.event.eventName;
    // String eventDescription = widget.event.eventDescription;
    // String? eventType = widget.event.eventType;
    // String eventDate = widget.event.eventDate;
    // String eventAddress = widget.event.eventAddress;
    // String eventAddress2 = widget.event.eventAddress2;
    // String eventCountry = widget.event.eventCountry;
    // String eventState = widget.event.eventState;
    // String zipPostalCode = widget.event.eventZipPostalCode;

    List<CountryModel> _countrySubList = [];

    List<CountryModel> _countryList = [];
    // TextEditingController _dateController = TextEditingController();
    // TextEditingController country = TextEditingController();
    // TextEditingController state = TextEditingController();
    // TextEditingController city = TextEditingController();

    Future<void> _getCountry() async {
      _countryList.clear();
      var jsonString = await rootBundle
          .loadString('packages/country_state_city_pro/assets/country.json');
      List<dynamic> body = json.decode(jsonString);
      setState(() {
        _countryList =
            body.map((dynamic item) => CountryModel.fromJson(item)).toList();
        _countrySubList = _countryList;
      });
    }

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: seaSault,
      title: Center(
        child: Text(
          'Edit Event',
          style: TextStyle(color: Colors.grey[850]),
        ),
      ),
      content: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          width: 400,
          child: Form(
            key: _formKey,

            // height: 3440,
            child: Column(
              children: [
                TextFormField(
                  initialValue: ref.watch(eventNameProvider),
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventName,
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    ref.read(eventNameProvider.notifier).state = val;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: ref.watch(eventDescriptionProvider),
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventDescription,
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    ref.read(eventDescriptionProvider.notifier).state = val;
                  },
                ),
                SizedBox(height: 12),
                Container(
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: ref.watch(eventTypeProvider),
                    onChanged: (value) {
                      setState(() {
                        ref.read(eventTypeProvider.notifier).state = value!;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: ref.watch(eventTypeProvider),
                      hintStyle: TextStyle(color: Colors.grey[850]),
                      fillColor: Colors.grey[350],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey,
                              width: 3.0)),
                      errorStyle: TextStyle(
                        color: Colors.grey[850],
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.grey[850]),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Birthday Party',
                        child: Text('Birthday Party'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Bar Mitzvah',
                        child: Text('Bar Mitzvah'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Engagement',
                        child: Text('Engagement'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Wedding',
                        child: Text('Wedding'),
                      ),
                    ],
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Select an event type';
                    //   }
                    //   return null; // Validation passed
                    // },
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  // initialValue: widget.event.eventDate,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: ref.watch(selectedDateProvider) != null
                          ? DateFormat('MM/dd/yyyy')
                              .format(ref.watch(selectedDateProvider)!)
                          : DateFormat('MM/dd/yyyy').format(DateTime.parse(
                              ref.watch(eventDateProvider),
                            )),
                    ),
                  ),
                  onTap: () {
                    // Will set the date to today in case the user does not select a date.
                    ref.read(selectedDateProvider.notifier).state =
                        DateTime.now();
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => CalendarWidget(),
                    );
                  },
                  readOnly: true,
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventDate,
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  // validator: nameValidator,
                  onChanged: (val) {
                    // newListName = val;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: ref.watch(eventAddressProvider),
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventAddress,
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    ref.read(eventNameProvider.notifier).state = val;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: ref.watch(eventAddress2Provider),
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventAddress2,
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    ref.read(eventAddress2Provider.notifier).state = val;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => SelectCountryWidget(),
                    );
                  },
                  cursorColor: Colors.grey[850],
                  readOnly: true,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[350] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[350] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    hintText:
                        ref.watch(selectedCountryProvider) == 'Select Country'
                            ? ref.watch(eventCountryProvider)
                            : ref.watch(selectedCountryProvider),
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[350] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[350] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  // onChanged: (val) {
                  //   newListName = val;
                  // },
                ),
                SizedBox(height: 12),
                TextFormField(
                  // initialValue: widget.event.eventState,
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => SelectStateWidget(),
                    );
                  },
                  cursorColor: Colors.grey[850],
                  readOnly: true,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[350] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: ref.watch(selectedStateProvider) == 'Select State'
                        ? ref.watch(eventStateProvider)
                        : ref.watch(selectedStateProvider),
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  // onChanged: (val) {
                  //   newListName = val;
                  // },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: ref.watch(eventZipPostalCodeProvider),
                  cursorColor: Colors.grey[850],
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    // hintText: widget.event.eventZipPostalCode,

                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Colors.grey[350],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    ref.read(eventZipPostalCodeProvider.notifier).state = val;
                    // ref.read(createEventZipPostalCodeProvider.notifier).state =
                    //     zipPostalCode;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              // Should refactor this its long
              if (_formKey.currentState!.validate()) {
                if (ref.read(selectedDateProvider) != null &&
                    ref.read(selectedDateProvider).toString() !=
                        ref.watch(eventDateProvider)) {
                  ref.read(eventDateProvider.notifier).state =
                      ref.read(selectedDateProvider).toString();
                }
                if (ref.read(selectedCountryProvider) != 'Select Country') {
                  ref.read(eventCountryProvider.notifier).state =
                      ref.read(selectedCountryProvider);
                }
                if (ref.read(selectedStateProvider) != 'Select State') {
                  ref.read(eventStateProvider.notifier).state =
                      ref.read(selectedStateProvider);
                }
                // save to airtable
                await updateEventToAt(
                  ref.read(eventRecordIDProvider),
                  ref.read(userStreamProvider).value!.uid.toString(),
                  ref.read(eventNameProvider),
                  ref.read(eventDescriptionProvider),
                  ref.read(eventTypeProvider),
                  ref.read(eventDateProvider),
                  ref.read(eventAddressProvider),
                  ref.read(eventAddress2Provider),
                  ref.read(eventCountryProvider),
                  ref.read(eventStateProvider),
                  ref.read(eventZipPostalCodeProvider),
                );
                // save to shared preference
                await editEventInSP(
                  ref.read(eventRecordIDProvider),
                  ref.read(eventNameProvider),
                  ref.read(eventDescriptionProvider),
                  ref.read(eventTypeProvider),
                  ref.read(eventDateProvider),
                  ref.read(eventAddressProvider),
                  ref.read(eventAddress2Provider),
                  ref.read(eventCountryProvider),
                  ref.read(eventStateProvider),
                  ref.read(eventZipPostalCodeProvider),
                );
                // await _saveEventsToSP();
                print(ref.read(eventRecordIDProvider));
                await _resetProviders();
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: seaSault),
            ),
          ),
        ),
      ],
    );
  }

  // Future<void> _saveEventsToAT() async {
  //   uploadEventsToAt(
  //       widget.event.eventRecordID,
  //       ref.read(createEventNameProvider),
  //       ref.read(createEventDescriptionProvider),
  //       ref.read(selectedEventTypeProvider),
  //       ref.read(selectedDateProvider).toString(),
  //       ref.read(createEventAddressProvider),
  //       ref.read(createEventAddress2Provider),
  //       ref.read(selectedCountryProvider),
  //       ref.read(selectedStateProvider),
  //       ref.read(createEventZipPostalCodeProvider),
  //       ref.read(userStreamProvider).value!.uid.toString());
  // }

  Future<void> _resetProviders() async {
    ref.read(selectedStateProvider.notifier).state = 'Select State';
    ref.read(selectedCountryProvider.notifier).state = 'Select Country';
    ref.read(selectedDateProvider.notifier).state = null;
  }
}
