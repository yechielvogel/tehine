import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../../providers/contact_providers.dart';
import '../../../../providers/list_providers.dart';
import '../../../../providers/user_providers.dart';
import '../../../../shared/style.dart';
import '../../../bottom_sheet_widgets/country_state_picker/add_contact.dart';
import '../../../forms/create_list_form.dart';

void listScreenAddMenu(BuildContext context, WidgetRef ref) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final List<PopupMenuEntry<dynamic>> menuList =
      ref.read(listScreenAddMenuProvider);

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(0, 0),
        overlay.localToGlobal(overlay.size.bottomLeft(Offset.zero)),
      ),
      Offset.zero & overlay.size,
    ),
    items: menuList,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 8,
    color: Color(0xFFF5F5F5),
  ).then((value) async {
    if (value != null) {
      // print('Selected Option: $value');
    }
    if (value == 1) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateListForm(onSave: (String savedName) {
              // Handle the saved name here, if needed
              print('Saved Name: $savedName');
            });
          });
    }
    if (value == 2) {
      PermissionStatus status = await Permission.contacts.status;

      if (status.isDenied) {
        status = await Permission.contacts.request();
      }
      if (!status.isDenied) {
        await uploadContactsFromDevice(null, ref, false);
        showModalBottomSheet(
            backgroundColor: creamWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AddContactWidget(),
                  ],
                ));
        /* 
       Show a screen (maybe a full bottom sheet widget) with all contacts on device and with selectable and a 
       search bar and a add button on the top. 
       */
      }
      ;
    }
    if (value == 3) {
      PermissionStatus status = await Permission.contacts.status;

      if (status.isDenied) {
        status = await Permission.contacts.request();
      }
      if (!status.isDenied) {
        await uploadContactsFromDevice(
            ref.read(userStreamProvider).value?.uid, ref, true);
        await ref.refresh(contactsFromSharedPrefProvider);
        await ref.read(contactsProvider);
        await ref.read(selectedListProvider);
      }
      ;
    }
  });
}
// List<PopupMenuEntry<dynamic>> listScreenAddMenuList = [
//   PopupMenuItem(
//     child: Text('My List'),
//     value: 1,
//   ),
//   PopupMenuItem(
//     child: Text('All Tehine'),
//     value: 2,
//   ),
// ];
