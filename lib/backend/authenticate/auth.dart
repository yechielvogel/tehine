import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../api/contacts/airtable/get_contacts.dart';
import '../api/user/airtable/get_user_info_at.dart';
import '../api/user/shared_preferences/get_user_from_shared_preferences.dart';
import '../../providers/contact_providers.dart';
import '../../providers/event_providers.dart';
import '../../providers/reset_providers.dart';
import '../../shared/globals.dart' as globals;
import '../api/user/airtable/upload_user_info_at.dart';
import '../../models/users_model.dart';

final authProvider = Provider((ref) => AuthService());

// final userStreamProvider = StreamProvider<Users?>((ref) {
//   return ref.watch(authProvider).user;
// });

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebaseUser(
    User? user,
  ) {
    return user != null
        ? Users(uid: user.uid, username: user.displayName)
        : null;
  }

  Stream<Users?> get user {
    return _auth.authStateChanges().map((User? user) {
      // print('Auth state changed: $user');
      return _userFromFirebaseUser(user);
    });
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(
      String email, String password, ref, context) async {
    String device = '';
    if (Platform.isIOS) {
      device = 'IOS';
    } else if (Platform.isAndroid) {
      device = 'Android';
    } else
      device = 'Unknown';
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // this might work should try it.
      // String? uid = result.user?.uid;
      // await getUserRecordIDFromAT(ref, uid);
      User? user = result.user;
      // print(user);

      // send login details to airtable
      // Problem here with the order of getting the data
      // await getAllDataFromAtOnStart(context);

      await updateUserDeviceInfoToAt(user?.uid, device);

      /* 
      instead of calling uploadUserLoginRecordsToAt here we are calling in the 
      invitations tab (the first tap) 
      so we can set the ref.read(userRecordIdProvider) 
      */
      // await getUserRecordIDFromAT(ref, user?.uid);

      uploadUserLoginRecordsToAt(user?.uid, user?.email, user?.displayName,
          DateTime.now().toString(), device, globals.version);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      displayName, phoneNumber, firstName, lastName) async {
    DateTime dateNotString = DateTime.now();
    String dateCreated = dateNotString.toString();
    String device = '';
    if (Platform.isIOS) {
      device = 'IOS';
    } else if (Platform.isAndroid) {
      device = 'Android';
    } else
      device = 'Unknown';

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await user!.updateDisplayName(displayName);
      uploadUserInfoToAt(user.uid, firstName, lastName, user.email, phoneNumber,
          dateCreated, device, globals.version);
      // load user info from shared preferences

      // userInfoAt(user.uid, user.displayName);

      // Reload the user to get the updated information.
      await user!.reload();
      displayName = _auth.currentUser!.displayName;
      user = _auth.currentUser;
      phoneNumber = _auth.currentUser!.phoneNumber;

      // await DatabaseService(uid: user!.uid).updateUserData('yes');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut(ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await resetProviders(ref);
      await prefs.clear();
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // delete account

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print(e.toString());

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {}
  }

  //get name
// Future<String?> getUserName(String uid) async {
//   try {
//     final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (userDoc.exists) {
//       final userData = userDoc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
//       if (userData != null) {
//         return userData['name'] as String?;
//       }
//     }
//     return null;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
}
