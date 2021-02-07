import 'package:messenger_ui/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bubbleColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
