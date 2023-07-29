import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:social_app/core/constants/assets_constants.dart';
import 'package:social_app/features/auth/controller/auth_controller.dart';
import 'package:social_app/features/timeline/controller/timeline_controller.dart';

import '../../../core/common/loader.dart';
import '../../../models/user_model.dart';
import '../../../theme/pallete.dart';
import '../../timeline/screens/widgets/post.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void logout(WidgetRef ref) {
    ref.watch(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider) ?? UserModel.empty();
    final userId = user.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => logout(ref),
            icon: const Icon(
              LineAwesomeIcons.alternate_sign_out,
              size: 40,
              color: Palette.primary,
            ),
          ),
        ],
      ),
      body: ref.watch(getUserDataProvider(userId)).when(
            data: (data) {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/profile/update');
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image(
                                    image: NetworkImage(data.profilePic),
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Image.asset(
                                            AssetsConstants.defaultImage);
                                      }
                                    },
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
                      ),
                      const SizedBox(height: 10),
                      Text(user.name,
                          style: const TextStyle(
                              color: Palette.white, fontSize: 28)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ref.watch(postsByUserIdProvider(userId)).when(
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
                        child: ref.watch(postsByUserIdProvider(userId)).when(
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
            error: (e, s) => Text('$s'),
            loading: () => const Loader(),
          ),
    );
  }
}
