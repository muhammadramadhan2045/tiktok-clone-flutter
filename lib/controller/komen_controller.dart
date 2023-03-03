import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/komen.dart';

class KomenController extends GetxController {
  final Rx<List<Komen>> _komens = Rx<List<Komen>>([]);
  List<Komen> get komen => _komens.value;

  String _postId = '';
  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _komens.bindStream(firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((event) {
      List<Komen> retValue = [];
      for (var element in event.docs) {
        retValue.add(Komen.fromSnap(element));
      }
      return retValue;
    }));
  }

  postComment(String komenTeks) async {
    try {
      if (komenTeks.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();

        int len = allDocs.docs.length;
        Komen komen = Komen(
          username: (userDoc.data()! as dynamic)['username'],
          komen: komenTeks.trim(),
          datePublished: DateTime.now(),
          likes: [],
          dislike: [],
          profilPhoto: (userDoc.data()! as dynamic)['profilPhoto'],
          uid: (userDoc.data()! as dynamic)['uid'],
          komenId: 'Comment $len',
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(
              komen.toJson(),
            );
        DocumentSnapshot snap =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (snap.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar('Gagal membuat kome', e.toString());
    }
  }

  likeVideo(String id, String konten) async {
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
    var uid = authController.user.uid;

    if (konten == "likes") {
      if ((doc.data()! as Map<String, dynamic>)['likes'].contains(uid)) {
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        if ((doc.data()! as Map<String, dynamic>)['dislike'].contains(uid)) {
          await firestore
              .collection('videos')
              .doc(_postId)
              .collection('comments')
              .doc(id)
              .update({
            'dislike': FieldValue.arrayRemove([uid]),
          });
        }
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } else {
      if ((doc.data()! as Map<String, dynamic>)['dislike'].contains(uid)) {
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'dislike': FieldValue.arrayRemove([uid]),
        });
      } else {
        if ((doc.data()! as Map<String, dynamic>)['likes'].contains(uid)) {
          await firestore
              .collection('videos')
              .doc(_postId)
              .collection('comments')
              .doc(id)
              .update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        }
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .update({
          'dislike': FieldValue.arrayUnion([uid]),
        });
      }
    }
  }
}
