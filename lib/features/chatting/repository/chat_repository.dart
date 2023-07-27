import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';

import '../../../core/common/firebase_constants.dart';

class ChatRpository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final UserModel _currentUser;

  ChatRpository(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore,
      required UserModel currentUser})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _currentUser = currentUser;
  CollectionReference get _chats =>
      _firebaseFirestore.collection(FirebaseConstants.chatsCollection);

  //SEND MESSAGE
  Future<void> sendMessage(String recieverId, String messageText) async {
    //current user id
    final Timestamp timestamp = Timestamp.now();
    //create message
    final message = Message(
      senderId: _currentUser.uid,
      senderName: _currentUser.name,
      recieverId: recieverId,
      message: messageText,
      timestamp: timestamp,
    );

    //create room id
    final ids = [recieverId, _currentUser.uid];
    ids.sort();
    String roomId = ids.join("_");

    //add to firestore
    await _chats.doc(roomId).collection("messages").add(message.toMap());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String currentUid, String recieverId) {
    //what is the chat room?
    final ids = [recieverId, currentUid];
    ids.sort();
    String roomId = ids.join("_");

    final messages = _chats
        .doc(roomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
    return messages;
  }
}
