import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:tehine/api/user/get_user_info_at.dart';
import 'package:tehine/shared/loading.dart';

import '../../api/user/upload_user_info_at.dart';
import '../../authenticate/auth.dart';
import '../../authenticate/authenticate.dart';
import '../../models/users_model.dart';
import '../../providers/user_provider.dart';
import '../navigation_screens/navigation_screen.dart';

import 'package:flutter/material.dart';

class Wrapper extends ConsumerWidget {
  bool userInfoCalled = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);

    if (user.value == null) {
      print('User is null');
      return Authenticate();
    } else {
      print('there is a user');
      print('User UID: ${user.value?.uid}');
      print('User Name: ${user.value?.username}');

      return NavigationScreen();
    }
  }
}
