import 'package:cloud_firestore/cloud_firestore.dart';

class Komen {
  String username;
  String komen;
  final datePublished;
  List likes;
  List dislike;
  String profilPhoto;
  String uid;
  String komenId;

  Komen(
      {required this.username,
      required this.komen,
      required this.datePublished,
      required this.likes,
      required this.dislike,
      required this.profilPhoto,
      required this.uid,
      required this.komenId});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "komen": komen,
        "komenId": komenId,
        "likes": likes,
        "dislike": dislike,
        "datePublished": datePublished,
        "profilPhoto": profilPhoto,
      };

  static Komen fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data()! as Map<String, dynamic>;
    return Komen(
      username: snapshot['username'],
      uid: snapshot['uid'],
      komen: snapshot['komen'],
      komenId: snapshot['komenId'],
      likes: snapshot['likes'],
      dislike: snapshot['dislike'],
      datePublished: snapshot['datePublished'],
      profilPhoto: snapshot['profilPhoto'],
    );
  }
}
