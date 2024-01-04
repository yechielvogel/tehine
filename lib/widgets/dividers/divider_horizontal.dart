import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerHorizontalWidget extends StatelessWidget {
  final double height;
  const DividerHorizontalWidget({Key? key, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey[850],
        ),
      ),
    );
  }
}
