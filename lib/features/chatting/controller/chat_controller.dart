import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/chatting/repository/chat_repository.dart';

final chatControllerProvider = Provider(
    (ref) => ChatController(chatRpository: ref.read(chatRpositoryProvider)));

class ChatController {
  final ChatRpository _chatRpository;
  ChatController({required ChatRpository chatRpository})
      : _chatRpository = chatRpository;

  //SEND MESSAGE
  void sendMessage(String recieverId, String messageText) {
    _chatRpository.sendMessage(recieverId, messageText);
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String currentUid, String recieverId) {
    return _chatRpository.getMessages(currentUid, recieverId);
  }
}
