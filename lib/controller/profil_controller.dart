import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

class ProfilController extends GetxController {
  final Rx<Map<String, dynamic>> _userProfile = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userProfile => _userProfile.value;
  bool isFollowing = false;
  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['username'];
    String profilPhoto = userData['profilPhoto'];

    int likes = 0;
    int folower = 0;
    int folowing = 0;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var folowerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var folowingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    folower = folowerDoc.docs.length;
    folowing = folowingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userProfile.value = {
      'followers': folower.toString(),
      'following': folowing.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilPhoto': profilPhoto,
      'username': name,
      'thumbnail': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _userProfile.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _userProfile.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _userProfile.value.update('isFollowing', (value) => !value);
    update();
  }
}
