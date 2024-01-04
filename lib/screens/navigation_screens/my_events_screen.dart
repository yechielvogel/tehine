import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyEventsScreen extends ConsumerStatefulWidget {
 MyEventsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyEventsScreen> createState() =>
      _MyEventsScreenState();
}

class _MyEventsScreenState
    extends ConsumerState<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}