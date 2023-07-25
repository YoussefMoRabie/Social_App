import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/timeline/screens/widgets/post.dart';
import 'package:social_app/theme/pallete.dart';

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
                child: ListView.builder(
                  itemCount: dataArray.length,
                  itemBuilder: (context, index) {
                    return Post(
                        imageUrl: dataArray[index]['imageUrl'],
                        username: dataArray[index]['username'],
                        createdAt: dataArray[index]['createdAt'],
                        description: dataArray[index]['description'],
                        likes: dataArray[index]['likes'],
                        comments: dataArray[index]['comments']);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/timeline/post/1');
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
