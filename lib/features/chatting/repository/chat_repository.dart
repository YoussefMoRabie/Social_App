import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/core/providers/firestore_providers.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/models/message_model.dart';
import '../../../core/common/firebase_constants.dart';

final chatRpositoryProvider = Provider((ref) =>
    ChatRpository(firebaseFirestore: ref.read(firestoreProvider), ref: ref));

class ChatRpository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  ChatRpository(
      {required FirebaseFirestore firebaseFirestore, required Ref ref})
      : _firebaseFirestore = firebaseFirestore,
        _ref = ref;
  CollectionReference get _chats =>
      _firebaseFirestore.collection(FirebaseConstants.chatsCollection);

  //SEND MESSAGE
  Future<void> sendMessage(String recieverId, String messageText) async {
    final _currentUser = _ref.watch(userProvider.notifier).state!;
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
