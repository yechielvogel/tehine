import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/list_providers.dart';
import '../../providers/contact_providers.dart';
import '../tiles/contact_tiles/contact_tile_for_adding_to_list.dart';

class AddContactsToListWidget extends ConsumerStatefulWidget {
  AddContactsToListWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddContactsToListWidget> createState() =>
      _AddContactsToListWidgetState();
}

class _AddContactsToListWidgetState
    extends ConsumerState<AddContactsToListWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
                  child: Container(
                      child: Text(
                    /*
                    In theory should refactor all code to define in a function
                    where we will assign all providers to variables.
                    */
                    'Add To ${ref.read(selectedListProvider)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),   
                  )),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ref.read(filteredForAddingContacts).length,
                itemBuilder: (BuildContext context, int index) {
                  String name = '${ref.read(filteredForAddingContacts)[index].firstName} ' +
                      '${ref.read(filteredForAddingContacts)[index].lastName}';
                  // Should change the name of the widget below
                  // or just use the regular contactTileWidget
                  // or make a new one to be able to add stuff to it specifically
                  return ContactTileForAddingToListWidget(contactName: name, contact: ref.read(filteredForAddingContacts)[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}
