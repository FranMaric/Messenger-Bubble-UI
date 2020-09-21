import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      statusBarColor: Colors.lime[400],
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.lime[400],
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mesenger UI Challenge',
      home: Messenger(),
    );
  }
}

const double radius = 30;

class Messenger extends StatefulWidget {
  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  bool fingerDown = false;
  double messageBubbleX = 0;
  double messageBubbleY = 0;

  double exitBubbleX;
  double exitBubbleY;

  @override
  Widget build(BuildContext context) {
    if (exitBubbleX == null || exitBubbleY == null) {
      exitBubbleX = MediaQuery.of(context).size.width / 2 - radius;
      exitBubbleY = MediaQuery.of(context).size.height - 120;
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.lime[400],
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: fingerDown ? 0 : 200),
              left: messageBubbleX,
              top: messageBubbleY,
              child: GestureDetector(
                onPanCancel: () {
                  fingerDown = false;

                  if (messageBubbleX + radius <=
                      MediaQuery.of(context).size.width / 2) {
                    messageBubbleX = 0;
                  } else {
                    messageBubbleX =
                        MediaQuery.of(context).size.width - radius * 2;
                  }
                  setState(() {});
                },
                onPanStart: (details) => fingerDown = true,
                onTapDown: (details) => fingerDown = true,
                onPanEnd: (details) {
                  fingerDown = false;

                  if (messageBubbleX + radius <=
                      MediaQuery.of(context).size.width / 2) {
                    messageBubbleX = 0;
                  } else {
                    messageBubbleX =
                        MediaQuery.of(context).size.width - radius * 2;
                  }
                  setState(() {});
                },
                onPanUpdate: (details) => setState(() {
                  messageBubbleX += details.delta.dx;
                  messageBubbleY += details.delta.dy;
                }),
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: fingerDown,
              child: Positioned(
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
