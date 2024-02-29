import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
