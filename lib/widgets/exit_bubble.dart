import 'package:messenger_ui/constants.dart';
import 'package:flutter/material.dart';

class ExitBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'X',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
