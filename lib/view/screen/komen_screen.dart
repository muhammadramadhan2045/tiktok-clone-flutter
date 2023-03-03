import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:timeago/timeago.dart' as tg;
import 'package:tiktok_clone/controller/komen_controller.dart';

class KomenScreen extends StatefulWidget {
  final String id;
  const KomenScreen({super.key, required this.id});

  @override
  State<KomenScreen> createState() => _KomenScreenState();
}

class _KomenScreenState extends State<KomenScreen> {
  final TextEditingController _komenController = TextEditingController();
  KomenController komenController = Get.put(KomenController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    komenController.updatePostId(widget.id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: komenController.komen.length,
                    itemBuilder: (context, index) {
                      final data = komenController.komen[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data.profilPhoto),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.username,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              data.komen,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(children: [
                                Text(
                                  tg.format(data.datePublished.toDate()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${data.likes.length} likes',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => komenController.likeVideo(
                                      data.komenId,
                                      "likes",
                                    ),
                                    child: Icon(
                                      data.likes.contains(
                                              firebaseAuth.currentUser!.uid)
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      size: 25,
                                      color: data.likes.contains(
                                              firebaseAuth.currentUser!.uid)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => komenController.likeVideo(
                                      data.komenId,
                                      '',
                                    ),
                                    child: Icon(
                                      data.dislike.contains(
                                              firebaseAuth.currentUser!.uid)
                                          ? Icons.thumb_down
                                          : Icons.thumb_down_alt_outlined,
                                      size: 25,
                                      color: data.dislike.contains(
                                              firebaseAuth.currentUser!.uid)
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _komenController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Komentar',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    komenController.postComment(_komenController.text);
                    setState(() {
                      _komenController.clear();
                    });
                  },
                  child: const Text(
                    'Kirim',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
