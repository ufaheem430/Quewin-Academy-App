import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'landing_screen.dart';
import 'tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    initial();
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/splash.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void initial() async {
    // await lockSystem(context);
    donLogin();
  }

  void donLogin() {
    String? token;
    Future.delayed(const Duration(seconds: 3), () async {
      token = await SharedPreferenceHelper().getAuthToken();
      if (token != null && token!.isNotEmpty) {
        Navigator?.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TabsScreen()));
      } else {
        Navigator?.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LandingPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : Container(),
          // child: Image.asset(
          //   'assets/images/splash.png',
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}
