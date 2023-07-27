import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../theme/pallete.dart';
import '../Widgets/message_textfield.dart';
import '../Widgets/single_message.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({super.key, 
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.surface,
        title: Row(
          mainAxisSize: MainAxisSize.min,
        
          children: [
           ClipRRect(
          
                          borderRadius: BorderRadius.circular(80),
                          child: const Image(
                            width: 30,
                            height: 30,
                            image: AssetImage("assets/images/profile.jpg"),
                            fit: BoxFit.cover,
                          )),
            const SizedBox(
              width: 10,
            ),
            Text(
              friendName,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              currentUser.uid;
                          return SingleMessage(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(currentUser.uid, friendId),
        ],
      ),
    );
  }
}
