import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/timeline/screens/widgets/post.dart';
import 'package:social_app/theme/pallete.dart';

import '../controller/timeline_controller.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  void sendPost(BuildContext context) {
    context.go('/timeline/post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timeline'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
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
                                path: "timeline",
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
