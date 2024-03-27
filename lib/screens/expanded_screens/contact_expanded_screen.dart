import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tehine/shared/style.dart';

import '../../models/contact_model.dart';
import '../../widgets/info_blocks/event_info_block.dart';

class ContactExpandedScreenWidget extends ConsumerStatefulWidget {
  final ContactModel contact;
  ContactExpandedScreenWidget({
    required this.contact,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ContactExpandedScreenWidget> createState() =>
      _ContactExpandedScreenWidgetState();
}

class _ContactExpandedScreenWidgetState
    extends ConsumerState<ContactExpandedScreenWidget> {
  // late GoogleMapController mapController;
  // final LatLng targetLocation = LatLng(37.7749, -122.4194);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: seaSault,
        elevation: 0,
        iconTheme: IconThemeData(color: steelBlue),
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // SizedBox(width: 5),
              IconButton(
                icon: Icon(
                  CupertinoIcons.share_solid,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {},
              ),

              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {
                  // Function to open form to edit
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
      backgroundColor: seaSault,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/BlankImage.jpg'),
                fit: BoxFit.cover, // You can adjust the fit property as needed
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
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
                    content: widget.contact.firstName +
                        ' ' +
                        widget.contact.lastName,
                  ),
                  EventAndContactInfoBlock(
                    title: 'Phone',
                    content: widget.contact.phoneNumber,
                  ),
                  EventAndContactInfoBlock(
                    title: 'Email',
                    content: widget.contact.email,
                  ),
                  EventAndContactInfoBlock(
                      title: 'Address',
                      content:
                          '${widget.contact.addressStreet.toString()} ${widget.contact.addressCity.toString()} ${widget.contact.addressZip.toString()}'
                      // content: widget.contact.address,
                      ),
                  EventAndContactInfoBlock(
                    title: 'Lists',
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
}
