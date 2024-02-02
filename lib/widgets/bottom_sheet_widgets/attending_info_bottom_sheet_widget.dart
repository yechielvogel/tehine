import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/models/contact_model.dart';

import '../../models/event_model.dart';

class AttendingInfoWidget extends ConsumerStatefulWidget {
  AttendingInfoWidget({
    Key? key,
    required EventModel event,
  }) : super(key: key);

  @override
  ConsumerState<AttendingInfoWidget> createState() =>
      _AttendingInfoWidgetState();
}

class _AttendingInfoWidgetState extends ConsumerState<AttendingInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Text('Attending')),
        )
      ],
    ));
  }
}
