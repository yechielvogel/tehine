import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/models/contact_model.dart';
import '../../models/event_model.dart';
import '../tiles/contact_tiles/contact_tile_for_attending.dart';

class AttendingInfoWidget extends ConsumerStatefulWidget {
  final int indexNumber;
  final EventModel event;
  AttendingInfoWidget({
    Key? key,
    required this.indexNumber,
    required this.event,
  }) : super(key: key);

  @override
  ConsumerState<AttendingInfoWidget> createState() =>
      _AttendingInfoWidgetState();
}

class _AttendingInfoWidgetState extends ConsumerState<AttendingInfoWidget> {
  late PageController _pageController;

  // pages

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.indexNumber);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      invited(widget.event),
      attending(widget.event),
      pending(widget.event),
      notAttending(widget.event),
    ];

    return PageView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _pageController,
      children: pages,
    );
  }
}

// pending

Widget pending(EventModel event) {
  List? pendingNames = event.pendingList;
  return Column(
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Container(
                child: Text(
              'Pending',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          itemCount: pendingNames?.length,
          itemBuilder: (BuildContext context, int index) {
            String name = pendingNames?[index];
            return ContactTileForAttendingWidget(contactName: name);
          },
        ),
      ),
    ],
  );
}

// attending
Widget attending(EventModel event) {
  List? attendingNames = event.attendingList;

  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
              child: Container(
                  child: Text(
                'Attending',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: attendingNames?.length,
            itemBuilder: (BuildContext context, int index) {
              String name = attendingNames?[index];
              return ContactTileForAttendingWidget(contactName: name);
            },
          ),
        ),
      ],
    ),
  );
}

// invited
Widget invited(EventModel event) {
  List? invitedNames = event.invitedList;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Container(
                child: Text(
              'Invited',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          itemCount: invitedNames?.length,
          itemBuilder: (BuildContext context, int index) {
            String name = invitedNames?[index];
            return ContactTileForAttendingWidget(contactName: name);
          },
        ),
      ),
    ],
  );
}

// not attending
Widget notAttending(EventModel event) {
  List? notAttendingNames = event.notAttendingList;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Container(
                child: Text(
              'Not Attending',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          itemCount: notAttendingNames?.length,
          itemBuilder: (BuildContext context, int index) {
            String name = notAttendingNames?[index];
            return ContactTileForAttendingWidget(contactName: name);
          },
        ),
      ),
    ],
  );
}
