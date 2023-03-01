import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/model/user.dart' as model;
import 'package:tiktok_clone/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/view/screen/auth/login_screen.dart';
import 'package:tiktok_clone/view/screen/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickedImage;
  late Rx<User?> _user;
  File? get profileFoto => _pickedImage.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(const LoginScreen());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar('Profile Picture', 'Berhasil memilih photo profil');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  //upload image ke ke firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStroage.ref().child('profilePics').child(
          firebaseAuth.currentUser!.uid,
        );
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //register
  void daftarUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //menyimpat data user ke auth dan firebase firesotre
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          email: email,
          username: username,
          profilPhoto: downloadUrl,
          uid: cred.user!.uid,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Pembuatan Akun Error', 'Isi semua field');
      }
    } catch (e) {
      Get.snackbar('Pembuatan Akun Error', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint('login succes');
      } else {
        Get.snackbar('Gagal Login Akun', 'Isi semua field');
      }
    } catch (e) {
      Get.snackbar('Gagal Login Akun', e.toString());
    }
  }
}
