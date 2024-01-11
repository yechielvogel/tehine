import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact_model.dart';
import 'load_data_from_device_on_start.dart';

final contactsFromSharedPrefProvider =
    FutureProvider<List<ContactModel>>((ref) async {
  return await loadContactsFromSP() ?? [];
});


final contactsProvider = StateProvider<List<ContactModel>>((ref) {
  final futureContacts = ref.watch(contactsFromSharedPrefProvider);
  return futureContacts.value ?? [];
});


final selectedContact = StateProvider<String>(
  (ref) => '',
);

// not sure this belongs here should find a better place 

final isSelectable = StateProvider<bool>(
  (ref) => false,
);

final selectedContacts = StateProvider<List<ContactModel>>(
  (ref) => [],
);



