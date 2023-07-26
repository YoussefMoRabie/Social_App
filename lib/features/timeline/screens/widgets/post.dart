import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/theme/pallete.dart';

import '../../../../core/utils.dart';
import '../../../../models/user_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/timeline_controller.dart';

class Post extends ConsumerWidget {
  final PostModel post;
  final bool? outside;

  Post({
    Key? key,
    required this.post,
    this.outside = false,
  }) : super(key: key);

  UserModel? postOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(getUserDataProvider(post.userId)).whenData((value) {
      postOwner = value;
    });

    void navgaiteToPostPage(String uuid) {
      context.go('/timeline/post/$uuid');
    }

    void pickReaction(BuildContext context, WidgetRef ref) async {
      final res = await pickImage();
      File? image;
      if (res != null) {
        image = File(res.files.first.path!);
      }

      // ignore: use_build_context_synchronously
      ref
          .read(timelineControllerProvider.notifier)
          .addComment(context: context, postId: post.id, file: image);
    }

    return InkWell(
      onTap: !outside! ? null : () => navgaiteToPostPage(post.id),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Palette.surface),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postOwner?.name ?? ".....",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      timeAgoSinceDate(post.createdAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // big image
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.content,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Palette.white),
              ),
            ),

            // like, comment, share
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${post.likes.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => pickReaction(context, ref),
                            icon: const Icon(
                              Icons.comment_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${post.commentCount}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.bookmark_border_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
