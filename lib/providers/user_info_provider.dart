import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authenticate/auth.dart';
import '../models/users_model.dart';

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


