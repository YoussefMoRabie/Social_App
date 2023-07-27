import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/timeline/screens/widgets/post.dart';
import 'package:social_app/theme/pallete.dart';

import '../controller/timeline_controller.dart';

class TimelineScreen extends ConsumerWidget {
  TimelineScreen({super.key});

  List<Map<String, dynamic>> dataArray = [
    {
      "imageUrl": "assets/images/60111.jpg",
      "username": "user123",
      "createdAt": "2023-07-25 12:34:56",
      "description": "This is the first post.",
      "likes": 50,
      "comments": 12,
    },
    {
      "imageUrl": "assets/images/profile.jpg",
      "username": "flutterFan",
      "createdAt": "2023-07-24 09:22:18",
      "description": "Check out this amazing Flutter app!",
      "likes": 101,
      "comments": 30,
    },
    {
      "imageUrl": "assets/images/profile.jpg",
      "username": "artlover",
      "createdAt": "2023-07-23 15:45:00",
      "description": "Beautiful artwork by an unknown artist.",
      "likes": 205,
      "comments": 45,
    },
    {
      "imageUrl": "assets/images/profile.jpg",
      "username": "foodie456",
      "createdAt": "2023-07-22 21:11:05",
      "description": "Delicious dinner at a local restaurant.",
      "likes": 85,
      "comments": 10,
    },
    {
      "imageUrl": "assets/images/profile.jpg",
      "username": "traveler789",
      "createdAt": "2023-07-21 17:30:42",
      "description": "Exploring new places and meeting new people!",
      "likes": 350,
      "comments": 70,
    },
  ];

  void sendPost(BuildContext context) {
    context.go('/timeline/post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timeline'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ref.watch(postsProvider).when(
                        data: (data) {
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Post(
                                outside: true,
                                post: data[index],
                              );
                            },
                          );
                        },
                        error: (e, s) => Text('$s'),
                        loading: () => const Loader(),
                      ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     context.go('/timeline/post/1');
                //   },
                //   child: const Text('Post'),
                // ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.primary,
          onPressed: () => sendPost(context),
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}
