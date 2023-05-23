import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leetcodestats/screens/user_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      //idk why by adding late final it dont gice error
      duration: Duration(seconds: 3),
      vsync: this)
    ..repeat();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserList())));
  }

  Widget _image_view() {
    return Center(
        child: Container(
            height: 200,
            width: 200,
            child: Image(
              image: AssetImage("images/leetcode.png"),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: controller, //controller is defined above
                child: _image_view(),
                builder: (context, Widget? child) {
                  return Transform.rotate(
                    //how to animate
                    angle: controller.value * 2 * 3.14,
                    child: child,
                  );
                }),
            SizedBox(
              height: 20,
            ),
            Text(
              "Leetcode Stats",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
