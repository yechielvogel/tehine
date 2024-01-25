import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
// import 'package:country_picker/country_picker.dart';

import '../../api/events/airtable/upload_events.dart';
import '../../api/events/shared_preferences/get_event_from_shared_preference.dart';
import '../../api/events/shared_preferences/save_event_to_shared_preferences.dart';
import '../../models/country_model.dart';
import '../../models/event_model.dart';
import '../../providers/create_event_providers.dart';
import '../../providers/date_providers.dart';
import '../../providers/event_providers.dart';
import '../../providers/general_providers.dart';
import '../../providers/list_providers.dart';
import '../../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../providers/user_providers.dart';
import '../calendar_widget.dart';
import '../select_country_widget.dart';
import '../select_state_widget.dart';

// This needs refactoring should make one class for the fields.

class MyEventsScreenAddEventPopUpForm extends ConsumerStatefulWidget {
  final void Function(String) onSave;
  const MyEventsScreenAddEventPopUpForm({required this.onSave, Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _MyEventsScreenAddEventPopUpFormState();
}

class _MyEventsScreenAddEventPopUpFormState
    extends ConsumerState<MyEventsScreenAddEventPopUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedName;

  // Maybe make this a ref
  String stateValue = "";

  String? nameValidator(String? val) {
    if (val!.isEmpty) {
      return 'Enter Name';
    } else if (val.contains(',')) {
      return 'Name should not contain a comma';
    } else {
      return null; // Validation passed
    }
  }

  String? addressValidator(String? val) {
    if (val!.isEmpty) {
      return 'Enter Address';
    } else {
      return null; // Validation passed
    }
  }

  String? countryValidator() {
    if (ref.read(selectedCountryProvider.notifier).state == 'Select Country') {
      return 'Select Country';
    } else {
      return null; // Validation passed
    }
  }

  String? stateValidator() {
    if (ref.read(selectedStateProvider.notifier).state == 'Select State') {
      return 'Select State';
    } else {
      return null; // Validation passed
    }
  }

  String? zipPostalCodeValidator(String? val) {
    if (val!.isEmpty) {
      return 'Enter Zip/Postal Code';
    } else {
      return null; // Validation passed
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String eventName = '';
    String eventDescription = '';
    String eventAddress = '';
    String eventAddress2 = '';
    String zipPostalCode = '';

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
      backgroundColor: Color(0xFFF5F5F5),
      title: Center(
        child: Text(
          'Create Event',
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
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Event Name',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  validator: nameValidator,
                  onChanged: (val) {
                    eventName = val;
                    ref.read(createEventNameProvider.notifier).state =
                        eventName;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
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
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    eventDescription = val;
                    ref.read(createEventDescriptionProvider.notifier).state =
                        eventDescription;
                  },
                ),
                SizedBox(height: 12),
                Container(
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: selectedName,
                    onChanged: (value) {
                      setState(() {
                        selectedName = value;
                        ref.read(selectedEventTypeProvider.notifier).state =
                            selectedName!;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Event Type',
                      hintStyle: TextStyle(color: Colors.grey[850]),
                      fillColor: Color(0xFFF5F5F5),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey[850] ?? Colors.grey,
                              width: 3.0)),
                      errorStyle: TextStyle(
                        color: Colors.grey[850],
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey, width: 3.0),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select an event type';
                      }
                      return null; // Validation passed
                    },
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: ref.watch(selectedDateProvider) != null
                          ? DateFormat('MM/dd/yyyy')
                              .format(ref.watch(selectedDateProvider)!)
                          : 'Enter date',
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
                            color: Colors.grey[850] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Select Date',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
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
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Address',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  validator: addressValidator,
                  onChanged: (val) {
                    eventAddress = val;
                    ref.read(createEventAddressProvider.notifier).state =
                        eventAddress;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
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
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Address 2',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  onChanged: (val) {
                    eventAddress2 = val;
                    ref.read(createEventAddress2Provider.notifier).state =
                        eventAddress2;
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
                        color: Colors.grey[850] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    hintText: ref.watch((selectedCountryProvider)),
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey,
                        width: 3.0,
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  validator: (value) => countryValidator(),
                  // onChanged: (val) {
                  //   newListName = val;
                  // },
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
                      builder: (context) => SelectStateWidget(),
                    );
                  },
                  cursorColor: Colors.grey[850],
                  readOnly: true,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.grey[850] ?? Colors.grey,
                            width: 3.0)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: ref.watch((selectedStateProvider)),
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  validator: (value) => stateValidator(),
                  // onChanged: (val) {
                  //   newListName = val;
                  // },
                ),
                SizedBox(height: 12),
                TextFormField(
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
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    hintText: 'Zip/Postal Code',
                    hintStyle: TextStyle(color: Colors.grey[850]),
                    fillColor: Color(0xFFF5F5F5),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[850]),
                  validator: zipPostalCodeValidator,
                  onChanged: (val) {
                    zipPostalCode = val;
                    ref.read(createEventZipPostalCodeProvider.notifier).state =
                        zipPostalCode;
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
              backgroundColor: Color(0xFFE6D3B3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _saveEventsToSP();
                await _saveEventsToAT();
                await resetProviders();
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.grey[850]),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveEventsToSP() async {
    List<EventModel> processedEvents = [];

    List<EventModel>? loadedEvents = await loadEventsFromSP();
    if (loadedEvents != null) {
      processedEvents.addAll(loadedEvents);
    }
    EventModel event = EventModel(
      eventName: ref.read(createEventNameProvider),
      eventDescription: ref.read(createEventDescriptionProvider),
      eventType: ref.read(selectedEventTypeProvider),
      eventDate: ref.read(selectedDateProvider).toString(),
      eventAddress: ref.read(createEventAddressProvider),
      eventAddress2: ref.read(createEventAddress2Provider),
      eventZipPostalCode: ref.read(createEventZipPostalCodeProvider),
      eventCountry: ref.read(selectedCountryProvider),
      eventState: ref.read(selectedStateProvider),
      invited: 0,
      attending: 0,
      pending: 0,
      notAttending: 0
      // eventMode: true,
    );
    processedEvents.add(event);
    saveEventsToSP(processedEvents);
  }

  Future<void> _saveEventsToAT() async {
    uploadEventsToAt(
        ref.read(createEventNameProvider),
        ref.read(createEventDescriptionProvider),
        ref.read(selectedEventTypeProvider),
        ref.read(selectedDateProvider).toString(),
        ref.read(createEventAddressProvider),
        ref.read(createEventAddress2Provider),
        ref.read(selectedCountryProvider),
        ref.read(selectedStateProvider),
        ref.read(createEventZipPostalCodeProvider),
        ref.read(userStreamProvider).value!.uid.toString());
  }

  Future<void> resetProviders() async {
    ref.read(selectedStateProvider.notifier).state = 'Select State';
    ref.read(selectedCountryProvider.notifier).state = 'Select Country';
    ref.read(selectedDateProvider.notifier).state = null;
  }
}
