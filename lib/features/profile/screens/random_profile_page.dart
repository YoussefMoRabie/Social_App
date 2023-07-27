import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/timeline/controller/timeline_controller.dart';
import 'package:social_app/models/user_model.dart';

import '../../../core/common/loader.dart';
import '../../../theme/pallete.dart';
import '../../timeline/screens/widgets/post.dart';

class RandomProfilePage extends ConsumerWidget {
  final String id;
  const RandomProfilePage({super.key, required this.id});

  void followAndUnfollow(BuildContext context, WidgetRef ref,
      String currentUserId, UserModel user) {
    if (user.followers.contains(currentUserId)) {
      print("here");
      ref
          .read(timelineControllerProvider.notifier)
          .unfollowPerson(context: context, userId: user.uid);
    } else {
      print("there");

      ref
          .read(timelineControllerProvider.notifier)
          .followPerson(context: context, userId: user.uid);
      // ref.refresh(getUserDataProvider(user.uid));
    }
  }

  void message(BuildContext context) {
    context.go("/contact");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userProvider)?.uid ?? "";
    return Scaffold(
      body: ref.watch(getUserDataProvider(id)).when(
            data: (data) {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image:
                                      AssetImage("assets/images/profile.jpg"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Palette.primary,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.alternate_pencil,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(data.name,
                          style: const TextStyle(
                              color: Palette.white, fontSize: 28)),
                      const SizedBox(height: 20),
                      currentUserId == data.uid
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Palette.primary,
                                      ),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () => followAndUnfollow(
                                            context,
                                            ref,
                                            currentUserId,
                                            data,
                                          ),
                                          child:  Text(
                                            data.followers.contains(currentUserId)
                                                ? "Unfollow"
                                                : "Follow",
                                            style: TextStyle(
                                              color: Palette.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Palette.primary),
                                      ),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () => message(context),
                                          child: const Text(
                                            "Message",
                                            style: TextStyle(
                                              color: Palette.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ref.watch(postsByUserIdProvider(data.uid)).when(
                                    data: (data) {
                                      return Text(
                                        data.length.toString(),
                                        style: const TextStyle(
                                          color: Palette.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                    error: (e, s) => Text('$s'),
                                    loading: () => const Loader(),
                                  ),
                              const Text(
                                "Posts",
                                style: TextStyle(color: Palette.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                data.followers.length.toString(),
                                style: const TextStyle(
                                  color: Palette.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(color: Palette.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                data.following.length.toString(),
                                style: const TextStyle(
                                  color: Palette.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(color: Palette.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Palette.primary,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ref.watch(postsByUserIdProvider(id)).when(
                              data: (data) {
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Post(
                                      path: "profile",
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
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: Loader()),
            error: (error, stack) => const Center(
              child: Text("Error"),
            ),
          ),
    );
  }
}
