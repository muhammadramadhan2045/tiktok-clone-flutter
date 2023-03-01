import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profilPhoto;
  final String username;

  const User({
    required this.email,
    required this.uid,
    required this.profilPhoto,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "profilPhoto": profilPhoto,
      };

  //taken document snapshot to return to user model
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      profilPhoto: snapshot['profilPhoto'],
    );
  }
}
