import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/features/timeline/controller/timeline_controller.dart';
import 'package:social_app/theme/pallete.dart';

class SendPostSreen extends ConsumerWidget {
  final TextEditingController _textEditingController = TextEditingController();

  SendPostSreen({super.key});

  void sendPost(BuildContext context, WidgetRef ref) {
    ref.read(timelineControllerProvider.notifier).addPost(
        context: context, postText: _textEditingController.text.trim());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () => sendPost(context, ref),
              child: const Text(
                "Send",
                style: TextStyle(color: Palette.primary, fontSize: 18),
              ),
            ),
          ],
        ),
        body:  Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _textEditingController,
                maxLines: 20,
                cursorColor: Palette.primary,
                style: TextStyle(color: Palette.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ));
  }
}
