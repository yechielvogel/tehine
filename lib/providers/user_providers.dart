import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend/authenticate/auth.dart';
import '../backend/api/user/shared_preferences/get_user_from_shared_preferences.dart';
import '../models/users_model.dart';

final userFromSharedPrefProvider = FutureProvider<Users?>((ref) async {
  return await loadUserFromSP();
});

final userProvider = StateProvider<Users?>((ref) {
  final futureUser = ref.watch(userFromSharedPrefProvider);
  return futureUser.value; // Access the value inside AsyncValue
});
/* 
This includes all the info that was asked for when signed up. 
use final user = ref.watch(userStreamProvider);
and then user.value!.uid 
*/

final userStreamProvider = StreamProvider<Users?>((ref) {
  return ref.watch(authProvider).user;
});

// final userInfoUploadedToAirTableProvider = StateProvider<bool>(
//   (ref) => false,
// );


/* 
This is for when the user signs in and it gets the record id but 
for some reason the ref.refresh is not getting the data straight away 
so using this temporarily 
*/ 
final userRecordIDProvider = StateProvider<String>(
  (ref) => '',
);


final userFirstNameProvider = StateProvider<String>(
  (ref) => '',
);

final userLastNameProvider = StateProvider<String>(
  (ref) => '',
);

final userFullNameProvider = StateProvider<String>(
  (ref) => '',
);

final userUserNameProvider = StateProvider<String>(
  (ref) => '',
);

final userDateCreatedProvider = StateProvider<String>(
  (ref) => '',
);

final userEmailProvider = StateProvider<String>(
  (ref) => '',
);

final userDeviceProvider = StateProvider<String>(
  (ref) => '',
);

final userLocationProvider = StateProvider<String>(
  (ref) => '',
);
