import 'dart:async';
import 'dart:io';
import 'package:academy_app/models/user.dart';
import 'package:flutter/material.dart';
// import 'package:zoom/zoom.dart';
import '../constants.dart';

class JoinWidget extends StatefulWidget {
  final String? meetingId;
  final String? meetingPassword;
  final String? appKey;
  final String? appSecret;

  const JoinWidget(
      {Key? key, this.meetingId, this.meetingPassword, this.appKey, this.appSecret})
      : super(key: key);

  @override
  State<JoinWidget> createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  Timer? timer;

  User user = User(email: '', firstName: '', lastName: '', role: '', userId: '');

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: const Text(
          'Loading meeting',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: joinMeeting(
          widget.meetingId, widget.meetingPassword, widget.appKey, widget.appSecret),
    );
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    } else {
      return status == "MEETING_STATUS_ENDED";
    }
  }

  joinMeeting(meetingId, meetingPassword, appKey, appSecret) {
    //   ZoomOptions zoomOptions = ZoomOptions(
    //     domain: "zoom.us",
    //     //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
    //     //https://jwt.io/
    //     //--todo from server
    //     //jwtToken: "your jwtToken",
    //     // appKey:
    //     //     "zv9V88C1XjPHsi5MwQZsFzZbK3snKeLeDsEj", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
    //     // appSecret:
    //     //     "GRbldTutMVRUTL9JmMO9j2NgKZ4r4nuMmBkO", // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
    //     appKey: appKey,
    //     appSecret: appSecret,
    //   );
    //   var meetingOptions = ZoomMeetingOptions(
    //       userId: user.firstName.toString(),
    //       // meetingId: '6751631508',
    //       // meetingPassword: 'wShUf3',
    //       meetingId: meetingId,
    //       meetingPassword: meetingPassword,
    //       disableDialIn: "true",
    //       disableDrive: "true",
    //       disableInvite: "true",
    //       disableShare: "false",
    //       noAudio: "false",
    //       noDisconnectAudio: "false");
    //   var zoom = Zoom();
    //   zoom.init(zoomOptions).then((results) {
    //     if (results[0] == 0) {
    //       zoom.onMeetingStateChanged.listen((status) {
    //         // ignore: avoid_print
    //         print("Meeting Status Stream: " + status[0] + " - " + status[1]);
    //         if (_isMeetingEnded(status[0])) {
    //           timer?.cancel();
    //         }
    //       });
    //       zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
    //         timer = Timer.periodic(const Duration(seconds: 2), (timer) {
    //           zoom.meetingStatus(meetingOptions.meetingId).then((status) {
    //             // ignore: avoid_print
    //             print("Meeting Status Polling: " + status[0] + " - " + status[1]);
    //           });
    //         });
    //       });
    //     }
    //   });
  }
}
