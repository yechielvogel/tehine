import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late GoogleMapController mapController;
  final LatLng targetLocation = LatLng(37.7749, -122.4194);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[850]),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/BlankImage.jpg'),
                  fit:
                      BoxFit.cover, // You can adjust the fit property as needed
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: Color(0xFFE6D3B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.grey[850],
                    ),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     elevation: 0,
                  //     fixedSize: Size(20, 50.0),
                  //     backgroundColor: Color(0xFFE6D3B3),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //   ),
                  //   onPressed: () {},
                  //   child: Icon(
                  //     Icons.attach_file_rounded,
                  //     color: Colors.grey[850],
                  //   ),
                  // ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: Color(0xFFE6D3B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(
                      CupertinoIcons.share_solid,
                      color: Colors.grey[850],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: Color(0xFFE6D3B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey[850],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: Color(0xFFE6D3B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey[850],
                    ),
                  ),
                ],
              ),
            )),
            EventAndContactInfoBlock(
              title: 'Name',
              content: widget.contact.firstName + ' ' + widget.contact.lastName,
            ),
            EventAndContactInfoBlock(
              title: 'Phone',
              content: widget.contact.phoneNumber,
            ),
            EventAndContactInfoBlock(
              title: 'Email',
              content: widget.contact.email,
            ),
            EventAndContactInfoBlock(title: 'Address', content: 'coming soon'
                // content: widget.contact.address,
                ),
            EventAndContactInfoBlock(
              title: 'Lists',
              content: 'Coming Soon',
            )
          ],
        ),
      ),
    );
  }
}
