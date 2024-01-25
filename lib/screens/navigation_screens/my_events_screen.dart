import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/event_model.dart';
import '../../providers/event_providers.dart';
import '../../widgets/forms/my_events_screen_add_event_pop_up_form.dart';
import '../../widgets/tiles/event_tiles/event_tile_widget.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
  MyEventsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends ConsumerState<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.refresh(eventsFromAirtableProvider);
    // final eventsAsyncValue = ref.read(eventsFromAirtableProvider);
    // final events = eventsAsyncValue.value ?? [];
    // print(eventsAsyncValue);

    ref.refresh(eventsFromSharedPrefProvider);

    final events = ref.watch(eventsProvider);
    // print(events.length);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Consumer(
        builder: (context, watch, child) {
          List<Widget> contactWidgets = [];

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    EventModel event = events[index];

                    return EventTileWidget(
                      event: event,
                      invited: event.invited,
                      attending: event.attending,
                      pending: event.pending,
                      notAttending: event.notAttending,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        onPressed: () async {
          await ref.refresh(eventsFromSharedPrefProvider);
          List<EventModel> events = ref.watch(eventsProvider);
          print(events.length);
          for (EventModel event in events) {
            print('Event Name: ${event.eventName}');
            print('Event Description: ${event.eventDescription}');
            print('Event Type: ${event.eventType}');
            print('Event Date: ${event.eventDate}');
            print('Event Address: ${event.eventAddress}');
            print('Event Address 2: ${event.eventAddress2}');
            print('Event Country: ${event.eventCountry}');
            print('Event State: ${event.eventState}');
            print('Event Zip/Postal Code: ${event.eventZipPostalCode}');
            // print('Event Mode: ${event.eventMode}');
            // print('-----------------------------');

            // print('Event Mode: ${event.eventMode}');
            // print('-----------------------------');
          }
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyEventsScreenAddEventPopUpForm(
                  onSave: (String savedName) {
                // Handle the saved name here, if needed
                print('Saved Name: $savedName');
              });
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Color(0xFFF5F5F5),
        ),
      ),
    );
  }
}
