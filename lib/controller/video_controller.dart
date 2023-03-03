import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(
      firestore.collection('videos').snapshots().map(
        (QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(
              Video.fromSnap(element),
            );
          }
          return retVal;
        },
      ),
    );
  }

  // likeVideo(String id) async {
  //   DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
  //   var uid = authController.user.uid;
  //   if ((doc.data()! as dynamic)['likes'].contains(uid)) {
  //     await firestore.collection('videos').doc(id).update({
  //       'likes': FieldValue.arrayRemove([uid]),
  //     });
  //   } else {
  //     await firestore.collection('videos').doc(id).update({
  //       'likes': FieldValue.arrayUnion([uid]),
  //     });
  //   }
  // }
  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    debugPrint("ini" + uid);

    if ((doc.data()! as Map<String, dynamic>)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
