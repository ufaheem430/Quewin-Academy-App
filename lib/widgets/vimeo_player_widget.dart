import 'package:academy_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerWidget extends StatefulWidget {
  final String? videoId;
  final UniqueKey? newKey;
  const VimeoPlayerWidget({Key? key, @required this.videoId, this.newKey})
      : super(key: key);

  @override
  _VimeoPlayerWidgetState createState() => _VimeoPlayerWidgetState();
}

class _VimeoPlayerWidgetState extends State<VimeoPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  child: VimeoPlayer(
                    videoId: widget.videoId.toString(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
