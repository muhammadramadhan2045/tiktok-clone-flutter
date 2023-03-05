import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controller/auth_controller.dart';
import 'package:tiktok_clone/view/screen/profil_screen.dart';
import 'package:tiktok_clone/view/screen/search_screen.dart';

import 'view/screen/add_video_screen.dart';
import 'view/screen/video_screen.dart';

//Navbar
List pages = [
  const VideoScreen(),
  const SearchScreen(),
  const AddVideoScreen(),
  const Text('Pesan Screen'),
  ProfilScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStroage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;
