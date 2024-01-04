import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerVerticalWidget extends StatelessWidget {
  final double height;
  const DividerVerticalWidget({
    Key? key, required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Container(
        width: 2,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey[850],
        ),
      ),
    );
  }
}
