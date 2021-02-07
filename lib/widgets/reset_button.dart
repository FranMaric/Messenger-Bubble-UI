import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final Function function;
  ResetButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(10),
        child: Text(
          'RESET',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
