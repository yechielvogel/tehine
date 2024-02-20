import 'package:tehine/providers/user_providers.dart';

import '../models/contact_model.dart';
import '../models/event_model.dart';
import 'contact_providers.dart';
import 'event_providers.dart';
import 'general_providers.dart';
import 'invitations_providers.dart';
import 'list_providers.dart';

Future<void> resetProviders(ref) async {
  // ref.read(eventsProvider.notifier).state = <List<EventModel>>[];
  // ref.read(eventListProvider.notifier).state = <List<EventModel>>[];
  // ref.read(contactsProvider.notifier).state = [];
  ref.read(searchQueryProvider.notifier).state = '';
// userProvider
  // User Providers
  // ref.read(userProvider.notifier).state = null;
  ref.read(userFirstNameProvider.notifier).state = '';
  ref.read(userLastNameProvider.notifier).state = '';
  ref.read(userFullNameProvider.notifier).state = '';
  ref.read(userUserNameProvider.notifier).state = '';
  ref.read(userEmailProvider.notifier).state = '';
  ref.read(userRecordIDProvider.notifier).state = '';
  // Contact Providers
  ref.invalidate(contactsFromSharedPrefProvider);
  ref.read(contactsProviderCheck.notifier).state = List<ContactModel>.empty();
  ref.read(contactsProvider.notifier).state = List<ContactModel>.empty();
  ref.read(filteredContactsProvider.notifier).state =
      List<ContactModel>.empty();
  // // Events Providers
  ref.invalidate(eventsFromSharedPrefProvider);
  // print('event provider length is before ${ref.read(eventsProvider).length}');
  ref.read(eventsProvider.notifier).state = List<EventModel>.empty();
  // print('event provider length is now ${ref.read(eventsProvider).length}');
  ref.read(eventsProviderCheck.notifier).state = List<EventModel>.empty();
  // invitations providers

  ref.read(invitationsProvider.notifier).state = List<EventModel>.empty();
  // print('restet invitlist ${ref.read(invitationsProvider).length}');
}
