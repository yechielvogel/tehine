import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authenticate/auth.dart';
import '../../authenticate/authenticate.dart';
import '../../models/users_model.dart';
import '../navigation_screens/navigation_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).user;
// final users = ref.read()
    if (user == null) {
      return Authenticate();
    } else {
//  print('User UID: ${user.uid}');
      return NavigationScreen();
    }
  }
}
      // print('this is ${user.uid}');
      // print('name is ${user.username}')