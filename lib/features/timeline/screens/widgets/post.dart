import 'package:flutter/material.dart';
import 'package:social_app/theme/pallete.dart';

import '../../../../core/utils.dart';

class Post extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String createdAt;
  final String description;
  final int likes;
  final int comments;

  const Post({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.createdAt,
    required this.description,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                backgroundImage: AssetImage(imageUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    timeAgoSinceDate(createdAt),
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
              description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Palette.white
              ),
              
          
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
                          "$likes",
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
                        const Icon(
                          Icons.comment_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "$comments",
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
    );
  }
}
