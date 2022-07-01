import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latsol/constants/r.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    this.id,
  }) : super(key: key);
  final String? id;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();
  late CollectionReference chat;
  late String roomName;

  @override
  void initState() {
    super.initState();
    roomName = widget.id ?? "kimia";
  }

  @override
  Widget build(BuildContext context) {
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc(roomName)
        .collection("chat");
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id ?? ""),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: chat.orderBy("time").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.reversed.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final currentChat =
                          snapshot.data!.docs.reversed.toList()[index];
                      final currentDate =
                          (currentChat["time"] as Timestamp?)?.toDate();
                      final currentUid = currentChat["uid"];
                      final currentName = currentChat["nama"];
                      final currentType = currentChat["type"];
                      final currentFile = currentChat["file_url"];
                      final currentContent = currentChat["content"];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: user.uid == currentUid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentName,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xff5200FF),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: user.uid == currentUid
                                    ? Colors.green.withOpacity(0.5)
                                    : const Color(0xffffdcdc),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: user.uid == currentUid
                                      ? const Radius.circular(0)
                                      : const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  topLeft: user.uid != currentUid
                                      ? const Radius.circular(0)
                                      : const Radius.circular(10),
                                ),
                              ),
                              child: currentType == "file"
                                  ? Image.network(
                                      currentFile,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(Icons.warning),
                                        );
                                      },
                                    )
                                  : Text(currentContent),
                            ),
                            Text(
                              currentDate == null
                                  ? ""
                                  : DateFormat("dd-MMM-yyy HH:mm")
                                      .format(currentDate),
                              style: TextStyle(
                                fontSize: 10,
                                color: R.colors.greySubtitleHome,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(
                      0.25,
                    ),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final imgResult =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        maxHeight: 500,
                                        maxWidth: 500,
                                      );

                                      if (imgResult != null) {
                                        File file = File(imgResult.path);
                                        String ref =
                                            "chat/$roomName/${user.uid}/${imgResult.name}";

                                        final imgResUpload =
                                            await FirebaseStorage.instance
                                                .ref()
                                                .child(ref)
                                                .putFile(file);

                                        final url = await imgResUpload.ref
                                            .getDownloadURL();

                                        final chatContent = {
                                          "nama": user.displayName,
                                          "uid": user.uid,
                                          "content": textController.text,
                                          "email": user.email,
                                          "photo": user.photoURL,
                                          "ref": ref,
                                          "type": "file",
                                          "file_url": url,
                                          "time": FieldValue.serverTimestamp(),
                                        };
                                        chat.add(chatContent).whenComplete(() {
                                          textController.clear();
                                        });
                                      }
                                    },
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Tulis pesan disini..",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      if (textController.text.isEmpty) {
                        return;
                      }

                      final chatContent = {
                        "nama": user.displayName,
                        "uid": user.uid,
                        "content": textController.text,
                        "email": user.email,
                        "photo": user.photoURL,
                        "ref": null,
                        "type": "text",
                        "file_url": null,
                        "time": FieldValue.serverTimestamp(),
                      };
                      chat.add(chatContent).whenComplete(() {
                        textController.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
