import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../backend/authenticate/authenticate.dart';
import '../../providers/user_providers.dart';
import '../navigation_screens/navigation_screen.dart';

import 'package:flutter/material.dart';

class Wrapper extends ConsumerWidget {
  bool userInfoCalled = false;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userStreamProvider);

    if (user.value == null) {
      // print('User is null');
      return Authenticate();
    } else {
      // print('there is a user');
      // print('User UID: ${user.value?.uid}');
      // print('User Name: ${user.value?.username}');
      return NavigationScreen();
    }
  }
}
