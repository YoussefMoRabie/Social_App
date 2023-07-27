import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/core/common/loader.dart';
import 'package:social_app/theme/pallete.dart';

import '../controller/leaderboard_controller.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Rank"), Text("username"), Text("Score")],
              ),
            ),
            ref.watch(leaderboardProvider).when(
                  data: (users) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Palette.primary, width: 1)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text((index + 1).toString()),
                                Text(users[index].name),
                                Text(users[index].score.toString()),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (e, s) => Text('$s'),
                  loading: () => const Center(child: Loader()),
                )
          ],
        ),
      )),
    );
  }
}
