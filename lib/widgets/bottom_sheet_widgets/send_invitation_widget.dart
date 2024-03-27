import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/user_providers.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_sms/flutter_sms.dart';

import '../../backend/api/events/airtable/upload_events.dart';
import '../../models/contact_model.dart';
import '../../models/event_model.dart';
import '../../providers/contact_providers.dart';
import '../../providers/event_providers.dart';
import '../../providers/list_providers.dart';
import '../../shared/style.dart';

class SendInvitationWidget extends ConsumerStatefulWidget {
  SendInvitationWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SendInvitationWidget> createState() =>
      _SendInvitationWidgetState();
}

class _SendInvitationWidgetState extends ConsumerState<SendInvitationWidget> {
  @override
  void initState() {
    super.initState();
  }

  List<String> recipients = [''];
  List<String> recipientsUserRecordId = [''];

  List<String>? attachments = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20.0, left: 50, bottom: 40, right: 50),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: ashGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      await _getAllContactsEmail(ref);
                      await _getAllContactsUserRecordId(ref);
                      await sendTehineInvitations(ref);
                      await _getAttachment(ref);
                      // await sendTehineInvitations(ref);
                      await sendEmail();
                      // await sendEmail();
                    },
                    child: Icon(
                      CupertinoIcons.mail,
                      size: 35,
                      color: darkGrey,
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: Size(20, 50.0),
                      backgroundColor: ashGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      await _getAllContactsPhone(ref);
                      await _getAttachment(ref);
                      // await _sendSMS();
                      await sendTehineInvitations(ref);
                    },
                    child: Icon(
                      CupertinoIcons.chat_bubble,
                      size: 35,
                      color: darkGrey,
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    fixedSize: Size(20, 50.0),
                    backgroundColor: ashGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    // await _getAllContactsPhone(ref);
                    await _getAttachment(ref);
                    await sendTehineInvitations(ref);

                    // await sendWhatsApp();
                  },
                  child: ImageIcon(
                    AssetImage('lib/assets/images/whatsappIcon.webp'),
                    size: 40,
                    color: darkGrey,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  List<String> phoneNumbers = ["+16464206057"];

  // Future<void> sendWhatsApp() async {
  //   // String url = "whatsapp://send?phone=+447709004207&text=test";
  //   String message = 'test';
  //   String phones = phoneNumbers.map((phoneNumber) => "$phoneNumber").join(",");

  //   String url =
  //       "whatsapp://send?phone=$phones&text=${Uri.encodeFull(message)}";

  //   launchUrl(Uri.parse(url));
  // }

  // Future<void> _sendSMS() async {
  //   String message = 'Please join us for the...';
  //   List<String> contacts = recipients;
  //   String _result = await sendSMS(message: message, recipients: contacts)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }

  // bool isHTML = false;
  // final _subjectController = TextEditingController(text: 'The subject');

  // final _bodyController = TextEditingController(
  //   text: 'Mail body.',
  // );

  Future<void> sendEmail() async {
    // The email button below worked in the terminal but not yet in the email.

    final String apiKey =
        'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
    final String? eventRecordID = ref.read(eventRecordIDProvider);
    final String? userRecordID = recipientsUserRecordId.toString();

    final String htmlContent = '''
    <p>You've been invited to an event! Click the button below to accept the invitation:</p>
    <p><button id="acceptButton" style="background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">Accept Invitation</button></p>
    <script>
        document.getElementById('acceptButton').addEventListener('click', function() {
            var xhr = new XMLHttpRequest();
            xhr.open('PATCH', 'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events/$eventRecordID', true);
            xhr.setRequestHeader('Authorization', 'Bearer $apiKey');
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify({ fields: { Attending: ['$userRecordID'] } }));
            alert('Invitation accepted!');
        });
    </script>
  ''';

    final Email email = Email(
      body: htmlContent,
      subject: '${ref.read(eventNameProvider)} + ${recipientsUserRecordId}',
      recipients: [ref.read(userEmailProvider)],
      // cc: ['cc@example.com'],
      bcc: recipients,
      attachmentPaths: attachments,
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  //   try {
  //     await FlutterEmailSender.send(email);
  //   } catch (error) {
  //     print('Error sending email: $error');
  //     // show dialog saying you don't have a default email setup on your device
  //     // maybe add click here to add one. (with a link)
  //   }
  // }

  Future<void> _getAttachment(ref) async {
    EventModel event = ref.read(selectedEventProvider);
    attachments!.add(event.attachment.toString());
    // print(attachments);
  }

  Future<void> _getAllContactsEmail(ref) async {
    List<String> refString = ref.read(eventListProvider);

    List<ContactModel> contacts = ref.watch(contactsProvider);

    for (ContactModel contact in contacts) {
      if (contact.lists.any((listItem) => refString.contains(listItem))) {
        if (contact.email.isNotEmpty) {
          recipients.add(contact.email);
          // print(recipients);
        }
      }
    }
  }

  Future<void> _getAllContactsUserRecordId(ref) async {
    List<String> refString = ref.read(eventListProvider);

    List<ContactModel> contacts = ref.watch(contactsProvider);

    for (ContactModel contact in contacts) {
      if (contact.lists.any((listItem) => refString.contains(listItem))) {
        if (contact.email.isNotEmpty) {
          recipientsUserRecordId.add(contact.userRecordID.toString());
          // print(recipients);
        }
      }
    }
  }

  Future<void> _getAllContactsPhone(ref) async {
    List<String> refString = ref.read(eventListProvider);

    List<ContactModel> contacts = ref.watch(contactsProvider);

    for (ContactModel contact in contacts) {
      if (contact.lists.any((listItem) => refString.contains(listItem))) {
        if (contact.phoneNumber.isNotEmpty) {
          recipients.add(contact.phoneNumber);
          print(recipients);
        }
      }
    }
  }

  Future<void> sendTehineInvitations(ref) async {     
    List<String> refString = ref.read(eventListProvider);

    List<ContactModel> contacts = ref.watch(contactsProvider);
    for (ContactModel contact in contacts) {
      if (contact.lists.any((listItem) => refString.contains(listItem))) {
        if (contact.userRecordID != '') {
          recipients.add(contact.userRecordID.toString());
        }
      }
    }

    inviteTehineUserToEventToAt(ref.read(eventRecordIDProvider), recipients);

    // call a function to invite the contact
  }
}

//

// for testing

// class TabBarApp extends StatelessWidget {
//   const TabBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const TabBarExample(),
//     );
//   }
// }

// class TabBarExample extends StatelessWidget {
//   const TabBarExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 1,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('TabBar Sample'),
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 icon: Icon(Icons.cloud_outlined),
//               ),
//               Tab(
//                 icon: Icon(Icons.beach_access_sharp),
//               ),
//               Tab(
//                 icon: Icon(Icons.brightness_5_sharp),
//               ),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: <Widget>[
//             Center(
//               child: Text("It's cloudy here"),
//             ),
//             Center(
//               child: Text("It's rainy here"),
//             ),
//             Center(
//               child: Text("It's sunny here"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
