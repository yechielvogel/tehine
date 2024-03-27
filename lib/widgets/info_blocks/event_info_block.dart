import 'package:flutter/material.dart';

import '../../shared/style.dart';

class EventAndContactInfoBlock extends StatelessWidget {
  final String title;
  final String content;

  EventAndContactInfoBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: seaSault,
            width: 1,
          ),
        )),
        height: 80,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 12,
                top: 12,
              ),
              child: Row(
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
