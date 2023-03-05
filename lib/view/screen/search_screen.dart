import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/search_controller.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/view/screen/profil_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onFieldSubmitted: (value) => searchController.searchUser(value),
            ),
          ),
          body: searchController.searchUsers.isEmpty
              ? const Center(
                  child: Text(
                    'Temukanlah user lain!',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: searchController.searchUsers.length,
                  itemBuilder: (context, index) {
                    User user = searchController.searchUsers[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilScreen(uid: user.uid),
                      )),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilPhoto),
                        ),
                        title: Text(
                          user.username,
                        ),
                      ),
                    );
                  },
                ));
    });
  }
}
