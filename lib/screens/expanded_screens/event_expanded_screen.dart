import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tehine/shared/style.dart';

import '../../backend/api/events/airtable/upload_events.dart';
import '../../backend/api/events/shared_preferences/save_event_to_shared_preferences.dart';
import '../../providers/event_providers.dart';
import '../../providers/list_providers.dart';
import '../../widgets/bottom_sheet_widgets/send_invitation_widget.dart';
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
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: steelBlue,
                  size: 25,
                ),

                // padding: EdgeInsets.all(0),
                onPressed: () async {
                  addListToInvitationMenu(context, ref);
                },
              ),
              // SizedBox(width: 5),
              IconButton(
                icon: Icon(
                  Icons.attach_file_rounded,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {
                  showModalBottomSheet(
                      backgroundColor: seaSault,
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
                                  color: grey400,
                                ),
                                title: Text('Camera'),
                                onTap: () => Navigator.of(context)
                                    .pop(pickImage(ImageSource.camera)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: ListTile(
                                  leading: Icon(Icons.image, color: grey400),
                                  title: Text('My Photos'),
                                  onTap: () => Navigator.of(context)
                                      .pop(pickImage(ImageSource.gallery)),
                                ),
                              ),
                            ],

                            // Attach a file photo/pdf (like a invitation)
                          ));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {
                  showModalBottomSheet(
                      backgroundColor: seaSault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SendInvitationWidget(),
                            ],
                          ));
                  // Send
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {
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
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: steelBlue,
                  size: 25,
                ),
                onPressed: () async {
                  // Delete From Airtable
                  await deleteEventFromUserAccountToAt(
                      ref.read(eventRecordIDProvider));
                  // Delete from shared preference

                  await deleteEventFromSP(ref.read(selectedEventProvider));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: seaSault,
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
            // SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [],
                ),
                // put the stats here
                ref.watch(eventListProvider).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5),
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
                                    selectedColor: seaSault,
                                    backgroundColor: lightGrey,
                                    label: Text(
                                      ref.watch(eventListProvider)[index],
                                      style: TextStyle(
                                        color:
                                            // ref.watch(
                                            //             selectedListProvider) ==
                                            //         ref.watch(
                                            //             eventListProvider)[index]
                                            //     ? seaSault
                                            //     :
                                            darkGrey,
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
                    : SizedBox(
                        height: 10,
                      ),
              ],
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
          'event_attachment/event_attachment_id_${ref.read(eventRecordIDProvider)}');

      await referenceAttachment.putFile(attachmentTemporary!);
      uploadedUrl = await referenceAttachment.getDownloadURL();

      attachment = attachmentTemporary;
      await updateEventAttachmentToAt(
          ref.read(eventRecordIDProvider), uploadedUrl);
      await updateEventAttachmentInSP(
          ref.read(eventRecordIDProvider), uploadedUrl);

      // Navigator.of(context).pop();
    } catch (error) {
      print('Error picking/uploading image: $error');
    }
  }
}
