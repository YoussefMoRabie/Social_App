import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chat extends ConsumerStatefulWidget {
  final String recieverId;
  final String recieverName;
  const Chat({super.key, required this.recieverId, required this.recieverName});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        //messages==============================================
        // messageList(),
        //input==============================================
      ]),
    );
  }

  // Widget messageList() {
  //   return StreamBuilder(
  //     stream: ref
  //         .watch(chatControllerProvider)
  //         .getMessages(ref.read(userProvider)!.uid, widget.recieverId),
  //     builder: (context, snapshot) {},
  //   );
  // }
}
