import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/models/comment_model.dart';

import '../../../../core/utils.dart';
import '../../../../theme/pallete.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/timeline_controller.dart';

class Comment extends ConsumerWidget {
  final CommentModel comment;
  const Comment({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Palette.surface,
      ),
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
                    "Ali",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    timeAgoSinceDate(comment.createdAt),
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
          Row(
            children: [
              SizedBox(
                height: 200,
                width: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(timelineControllerProvider.notifier).upvoteComment(
                            context: context, comment: comment);
                      },
                      icon:  Icon(
                        Icons.arrow_upward,
                        color: comment.upvotes.contains(ref.read(userProvider)!.uid)
                            ? Palette.primary
                            : Colors.grey,
                        size: 40,
                      ),
                    ),
                    Text(
                      "${comment.upvotes.length - comment.downvotes.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        ref.read(timelineControllerProvider.notifier).downvoteComment(
                            context: context, comment: comment);
                      },
                      icon:  Icon(
                        Icons.arrow_downward,
                        color: comment.downvotes.contains(ref.read(userProvider)!.uid)
                            ? Palette.primary
                            : Colors.grey,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    comment.imageUrl,
                    width: 100,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}