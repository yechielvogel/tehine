import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../backend/api/events/airtable/get_events.dart';
import '../../models/event_model.dart';
import '../../providers/event_providers.dart';
import '../../shared/loading.dart';
import '../../widgets/forms/create_event_form.dart';
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
  void initState() {
    super.initState();      
    /*
    The following is called to check if there is any contacts on device
    if not it will call a function to check airtable and download contacts
    */
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      if (ref.watch(eventsProviderCheck).isEmpty) {
        initializeData();
        // await getAllEventsDataFromAtOnStart(context);
      }
    });
  }

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
          // for (EventModel event in events) {
          // }
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateEventForm(onSave: (String savedName) {
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

  Future<void> initializeData() async {
    // Reset
    // ref.read(contactsProvider.notifier).state = [];
    // // Refresh
    // ref.refresh(contactsFromSharedPrefProvider);
    // // Filter
    // ref.read(filteredContactsProvider);

    // ref.read(selectedListProvider.notifier).state = 'All';
    // ref.watch(selectedListScreenChipIndexProvider.state).state = 1;
    // print(ref.read(selectedListProvider));

    if (ref.watch(eventsProvider).isEmpty) {
      // Refresh
      ref.refresh(eventsFromSharedPrefProvider);
      // Filter
      // ref.read(filteredContactsProvider);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {    
          return Center(
            child: LoadingTransparent(),
          );
        },
      );
      try {
        await getAllEventsDataFromAtOnStart(context);
      } finally {
        Navigator.of(context).pop();
      }
    }
  }
}
