import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:priv_app/services/stream/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'login.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: MyConst.appId,
      appSign: MyConst.appSign,
      userID: MyConst.UserId,
      userName: MyConst.Name,
      callID: MyConst.callID,

      // Modify your custom configurations here.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..turnOnCameraWhenJoining = false
        ..turnOnMicrophoneWhenJoining = false
        ..useSpeakerWhenJoining = true,
      onDispose: () async {
        try {
          print("setting false");
          await FirebaseFirestore.instance
              .collection('call')
              .doc('value')
              .set({'id': false}, SetOptions(merge: true));
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
