import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:messenger_ui/constants.dart';
import 'package:messenger_ui/widgets/exit_bubble.dart';
import 'package:messenger_ui/widgets/message_bubble.dart';
import 'package:messenger_ui/widgets/reset_button.dart';

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
  bool fingerDown = false, attached = false, reset = false;
  double messageBubbleX = 0, messageBubbleY = 0;
  double exitBubbleX, exitBubbleY;
  double screenWidth, screenHeight;
  double angle, reach = startingReach, distance;

  @override
  Widget build(BuildContext context) {
    if (screenWidth == null || screenHeight == null) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;

      exitBubbleX = screenWidth / 2 - radius;
      exitBubbleY = screenHeight;
    }

    void onStart(DragStartDetails details) {
      fingerDown = true;
      setState(() {
        exitBubbleY = screenHeight - reach;
      });
    }

    void onUpdate(DragUpdateDetails details) {
      angle = atan((0.5 * screenWidth - messageBubbleX - radius) /
          (screenHeight - messageBubbleY - radius));

      setState(() {
        messageBubbleX += details.delta.dx;
        messageBubbleY += details.delta.dy;

        distance = pow(
            pow(screenWidth / 2 - messageBubbleX, 2) +
                pow(screenHeight - messageBubbleY, 2),
            0.5);

        if (distance < startingReach) {
          attached = true;
        } else {
          attached = false;
        }

        reach = startingReach * (distance / 400);

        if (reach > startingReach) {
          reach = startingReach;
        } else if (reach < startingReach / 2) {
          reach = startingReach / 2;
        }

        exitBubbleX = screenWidth / 2 - radius + cos(-angle - pi / 2) * reach;
        exitBubbleY = screenHeight + sin(-angle - pi / 2) * reach;
        if (exitBubbleY > screenHeight - 2 * radius) {
          exitBubbleY = screenHeight - 2 * radius;
        }
      });
    }

    void onEnd(DragEndDetails details) {
      fingerDown = false;

      setState(() {
        if (messageBubbleX + radius <= screenWidth / 2) {
          messageBubbleX = 0;
        } else {
          messageBubbleX = screenWidth - radius * 2;
        }

        if (attached) {
          reset = true;
        }

        exitBubbleY = screenHeight;
        exitBubbleX = screenWidth / 2 - radius;
        reach = startingReach;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: background,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: exitBubbleX,
              top: exitBubbleY,
              child: ExitBubble(),
            ),
            reset
                ? Center(
                    child: ResetButton(
                      function: () => setState(() {
                        fingerDown = false;
                        attached = false;
                        reset = false;
                        messageBubbleX = 0;
                        messageBubbleY = 0;
                      }),
                    ),
                  )
                : AnimatedPositioned(
                    duration: Duration(
                        milliseconds: attached ? 40 : (fingerDown ? 0 : 150)),
                    curve: Curves.easeIn,
                    left: attached == true ? exitBubbleX : messageBubbleX,
                    top: attached == true ? exitBubbleY : messageBubbleY,
                    child: GestureDetector(
                      onPanStart: onStart,
                      onPanUpdate: onUpdate,
                      onPanEnd: onEnd,
                      child: MessageBubble(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
