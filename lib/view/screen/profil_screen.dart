import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  final String uid;
  const ProfilScreen({super.key, required this.uid});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen ini milik user ${widget.uid}'),
      ),
    );
  }
}
