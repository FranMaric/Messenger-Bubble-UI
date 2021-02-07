import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: background,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mesenger UI Challenge',
      home: Messenger(),
    );
  }
}

class Messenger extends StatefulWidget {
  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  bool fingerDown = false;
  double messageBubbleX = 0, messageBubbleY = 0;

  double exitBubbleX, exitBubbleY;

  double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    if (screenWidth == null || screenHeight == null) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
    }

    void onStart(DragStartDetails details) {
      fingerDown = true;
      exitBubbleY = screenHeight - 120;
    }

    void onUpdate(DragUpdateDetails details) {
      messageBubbleX += details.delta.dx;
      messageBubbleY += details.delta.dy;

      setState(() {});
    }

    void onEnd(DragEndDetails details) {
      fingerDown = false;

      if (messageBubbleX + radius <= screenWidth / 2) {
        messageBubbleX = 0;
      } else {
        messageBubbleX = screenWidth - radius * 2;
      }

      exitBubbleY = screenHeight;

      setState(() {});
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: background,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: fingerDown ? 0 : 200),
              left: messageBubbleX,
              top: messageBubbleY,
              child: GestureDetector(
                onPanStart: onStart,
                onPanUpdate: onUpdate,
                onPanEnd: onEnd,
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: exitBubbleX,
              top: exitBubbleY,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  double calcDistance(x1, y1, x2, y2) =>
      pow(pow(x2 - x1, 2) + pow(y2 - y1, 2), 0.5);
}
