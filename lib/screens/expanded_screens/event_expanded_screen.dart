import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../api/events/airtable/upload_events.dart';
import '../../api/events/shared_preferences/save_event_to_shared_preferences.dart';
import '../../models/event_model.dart';
import '../../providers/event_providers.dart';
import '../../providers/general_providers.dart';
import '../../providers/list_providers.dart';
import '../../shared/loading.dart';
import '../../widgets/forms/edit_event_form.dart';
import '../../widgets/info_blocks/event_info_block.dart';
import '../../widgets/menus/list_menus/for_event_expanded_screen/add_list_to_invitation_menu.dart';
import 'attachment_expanded_screen.dart';

class EventExpandedScreenWidget extends ConsumerStatefulWidget {
  // final EventModel event;
  EventExpandedScreenWidget({
    // required this.event,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EventExpandedScreenWidget> createState() =>
      _EventExpandedScreenWidgetState();
}

class _EventExpandedScreenWidgetState
    extends ConsumerState<EventExpandedScreenWidget> {
  // late GoogleMapController mapController;
  // final LatLng targetLocation = LatLng(37.7749, -122.4194);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ref.refresh(eventListFromSharedPreferenceProvider);
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullImageScreen(
                            ref.read(eventAttachmentProvider))));
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ref.watch(eventAttachmentProvider) != null &&
                            ref.watch(eventAttachmentProvider)!.isNotEmpty
                        ? NetworkImage(
                            ref.watch(eventAttachmentProvider)
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
                      onPressed: () {
                        addListToInvitationMenu(context, ref);
                      },
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
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
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[850],
                                      ),
                                      title: Text('Camera'),
                                      onTap: () => Navigator.of(context)
                                          .pop(pickImage(ImageSource.camera)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: ListTile(
                                        leading: Icon(Icons.image,
                                            color: Colors.grey[850]),
                                        title: Text('My Photos'),
                                        onTap: () => Navigator.of(context).pop(
                                            pickImage(ImageSource.gallery)),
                                      ),
                                    ),
                                  ],

                                  // Attach a file photo/pdf (like a invitation)
                                ));
                      },
                      child: Icon(
                        Icons.attach_file_rounded,
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
                        Icons.send,
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditEventForm(
                              onSave: (String savedName) {
                                // Handle the saved name here, if needed
                                print('Saved Name: $savedName');
                              },
                              // event: widget.event,
                            );
                          },
                        );

                        // Function to open form to edit
                      },
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
                      onPressed: () async {
                        // Delete From Airtable
                        await deleteEventFromUserAccountToAt(
                            ref.read(eventIDProvider));
                        // Delete from shared preference

                        await deleteEventFromSP(
                            ref.read(selectedEventProvider));
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey[850],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [],
                ),
                // put the stats here
                ref.watch(eventListProvider).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 8),
                        child: SizedBox(
                          height: 50, // specify the desired height,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int index = 0;
                                  index < ref.watch(eventListProvider).length;
                                  index++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: ChoiceChip(
                                    selectedColor: Color(0xFFE6D3B3),
                                    backgroundColor: Color(0xFFE6D3B3),
                                    label: Text(
                                      ref.watch(eventListProvider)[index],
                                      style: TextStyle(
                                        color: ref.watch(
                                                    selectedListProvider) ==
                                                ref.watch(
                                                    eventListProvider)[index]
                                            ? Colors.grey[850]
                                            : Colors.grey[850],
                                      ),
                                    ),
                                    selected: ref.watch(selectedListProvider) ==
                                        (ref.watch(eventListProvider)[index] ==
                                                -1
                                            ? ref.watch(eventListProvider).first
                                            : ref.watch(
                                                eventListProvider)[index]),
                                    pressElevation: 0,
                                    onSelected: (selected) async {
                                      /* Maybe bring a bottom sheet of all the contacts in the list 
                                  and then you could see whose coming.
                                  */
                                    },
                                  ),
                                ),
                              SizedBox(width: 7),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            // stats
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20, bottom: 0),
            //       child: Row(
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               //           showModalBottomSheet(
            //               //   shape: RoundedRectangleBorder(
            //               //     borderRadius: BorderRadius.vertical(
            //               //       top: Radius.circular(20),
            //               //     ),
            //               //   ),
            //               //   context: context,
            //               //   builder: (context) => AttendingInfoWidget(event: widget.event),
            //               // );
            //             },
            //             child: Icon(
            //               Icons.mail_outline, // Envelope icon
            //               color: Colors.grey[850],
            //               size: 20,
            //             ),
            //           ),
            //           SizedBox(
            //               width: 5), // Add some spacing between icon and count
            //           Text(
            //             '0', // Replace with your attendance count
            //             style: TextStyle(
            //               color: Colors.grey[850],
            //               fontSize: 14,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20, bottom: 0),
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.check_circle_outline,
            //             color: Colors.grey[850],
            //             size: 20,
            //           ),
            //           SizedBox(width: 5),
            //           Text(
            //             '0',
            //             style: TextStyle(
            //               color: Colors.grey[850],
            //               fontSize: 14,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20, bottom: 0),
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.schedule, // Envelope icon
            //             color: Colors.grey[850],
            //             size: 20,
            //           ),
            //           SizedBox(
            //               width: 5), // Add some spacing between icon and count
            //           Text(
            //             '0', // Replace with your attendance count
            //             style: TextStyle(
            //               color: Colors.grey[850],
            //               fontSize: 14,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20, bottom: 0),
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.cancel_outlined, // Envelope icon
            //             color: Colors.grey[850],
            //             size: 20,
            //           ),
            //           SizedBox(
            //               width: 5), // Add some spacing between icon and count
            //           Text(
            //             '0', // Replace with your attendance count
            //             style: TextStyle(
            //               color: Colors.grey[850],
            //               fontSize: 14,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            EventAndContactInfoBlock(
              title: 'Name',
              content: ref.watch(eventNameProvider),
            ),
            EventAndContactInfoBlock(
              title: 'Type',
              content: ref.watch(eventTypeProvider),
            ),
            EventAndContactInfoBlock(
              title: 'Date',
              content: DateFormat('MM/dd/yyyy').format(
                DateTime.parse(
                  ref.watch(eventDateProvider),
                ),
              ),
            ),
            EventAndContactInfoBlock(
              title: 'Address',
              content: ref.watch(eventAddressProvider),
            ),
            EventAndContactInfoBlock(
              title: 'Mode',
              content: 'Coming Soon',
            )
          ],
        ),
      ),
    );
  }

  File? attachment;
  String uploadedUrl = '';
  File? attachmentTemporary;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedAttachment = await ImagePicker().pickImage(source: source);
      if (pickedAttachment == null) return;
      attachmentTemporary = File(pickedAttachment.path);

      Reference referenceAttachment = FirebaseStorage.instance.ref().child(
          'event_attachment/event_attachment_id_${ref.read(eventIDProvider)}');

      await referenceAttachment.putFile(attachmentTemporary!);
      uploadedUrl = await referenceAttachment.getDownloadURL();

      attachment = attachmentTemporary;
      await updateEventAttachmentToAt(ref.read(eventIDProvider), uploadedUrl);
      await updateEventAttachmentInSP(ref.read(eventIDProvider), uploadedUrl);

      // Navigator.of(context).pop();
    } catch (error) {
      print('Error picking/uploading image: $error');
    }
  }
}
    



    //  showModalBottomSheet(
    //                             context: context,
    //                             builder: (context) => Column(
    //                                   mainAxisSize: MainAxisSize.min,
    //                                   children: [
    //                                     ListTile(
    //                                       leading: Icon(Icons.camera_alt),
    //                                       title: Text('Camera'),
    //                                       onTap: () => Navigator.of(context)
    //                                           .pop(AdditionalPickImage(
    //                                               ImageSource.camera)),
    //                                     ),
    //                                     ListTile(
    //                                       leading: Icon(Icons.image),
    //                                       title: Text('My Photos'),
    //                                       onTap: () => Navigator.of(context)
    //                                           .pop(AdditionalPickImage(
    //                                               ImageSource.gallery)),
    //                                     ),
    //                                   ],
    //                                 ));
    //                       },

// pick image

