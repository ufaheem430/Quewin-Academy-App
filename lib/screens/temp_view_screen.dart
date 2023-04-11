import 'package:academy_app/constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TempViewScreen extends StatefulWidget {
  static const routeName = '/temp-view';

  final String? videoUrl;

  const TempViewScreen({Key? key, this.videoUrl}) : super(key: key);

  @override
  _TempViewScreenState createState() => _TempViewScreenState();
}

class _TempViewScreenState extends State<TempViewScreen> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl.toString());
    // _initializeVideoPlayerFuture = _controller.initialize();
    flickManager = FlickManager(videoPlayerController: _controller);
    // _controller.setLooping(true);
    // _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final videoUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  // do something
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: FlickVideoPlayer(flickManager: flickManager),
            ),
          ),
        ],
      ),
    );
  }
}
