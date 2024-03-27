import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import '../../shared/style.dart';
import '../../widgets/info_blocks/event_info_block.dart';
import 'attachment_expanded_screen.dart';

class InvitationExpandedScreenWidget extends ConsumerStatefulWidget {
  final EventModel event;
  InvitationExpandedScreenWidget({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<InvitationExpandedScreenWidget> createState() =>
      _InvitationExpandedScreenWidgetState();
}

class _InvitationExpandedScreenWidgetState
    extends ConsumerState<InvitationExpandedScreenWidget> {
  // late GoogleMapController mapController;
  // final LatLng targetLocation = LatLng(37.7749, -122.4194);
  @override
  void initState() {
    super.initState();
  }

  String text = '';
  String subject = '';
  String uri = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    // ref.refresh(eventListFromSharedPreferenceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: seaSault,
        elevation: 0,
        iconTheme: IconThemeData(color: steelBlue),
      ),
      backgroundColor: seaSault,
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FullImageScreen(widget.event.attachment)));
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.event.attachment != null &&
                          widget.event.attachment!.isNotEmpty
                      ? NetworkImage(
                          widget.event.attachment
                              as String) as ImageProvider<
                          Object> // Explicitly cast to ImageProvider<Object>
                      : AssetImage('lib/assets/images/BlankImage.jpg')
                          as ImageProvider<
                              Object>, // Explicitly cast to ImageProvider<Object>
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Container(
              decoration: BoxDecoration(
                color: lightGrey,
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.grey.withOpacity(0.5),
                  //   spreadRadius: 2,
                  //   blurRadius: 3,
                  //   offset: Offset(0, 3),
                  // ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  EventAndContactInfoBlock(
                    title: 'Name',
                    content: widget.event.eventName.toString(),
                  ),
                  EventAndContactInfoBlock(
                    title: 'Type',
                    content: widget.event.eventType.toString(),
                  ),
                  EventAndContactInfoBlock(
                    title: 'Date',
                    content: DateFormat('MM/dd/yyyy').format(
                      DateTime.parse(
                        widget.event.eventDate.toString(),
                      ),
                    ),
                  ),
                  EventAndContactInfoBlock(
                    title: 'Address',
                    content: widget.event.eventAddress.toString(),
                  ),
                  EventAndContactInfoBlock(
                    title: 'Mode',
                    content: 'Coming Soon',
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  File? attachment;
  String uploadedUrl = '';
  File? attachmentTemporary;
}
