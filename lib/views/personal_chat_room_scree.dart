// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk_space/controller/chat/chat_bloc.dart';
import 'package:uuid/uuid.dart';

class PersonalChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String roomId;
  PersonalChatRoom({super.key, required this.userMap, required this.roomId});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  File? fileImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('user').doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Text(userMap['name']),
                Text(
                  snapshot.data?['status'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chatroom')
                  .doc(roomId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is FindUserLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SendMessageSuccessState) {
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>;
                            return message(size, map);
                          },
                        );
                      }
                      return const Center(child: Text('Chat with Your Friend'));
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 15,
              width: size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: size.height / 16,
                    width: size.width / 1.3,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () => pickImage(),
                            icon: const Icon(Icons.image_outlined)),
                        hintText: 'Type here ...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          context.read<ChatBloc>().add(
                                SendMessageEvent(
                                  roomId: roomId,
                                  authName: userMap['name'],
                                  message: messageController.text,
                                ),
                              );
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: true,
    );
  }

  Widget message(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == auth.currentUser?.displayName
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Text(
          map['message'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  pickImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        fileImage = File(xFile.path);
        print(fileImage);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');

    var uploadTask = await ref.putFile(fileImage!);
    print('called $uploadTask');
    String imageUrl = await uploadTask.ref.getDownloadURL();
    print('------------------------------');
    print(imageUrl);
  }
}
