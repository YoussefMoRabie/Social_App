import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/core/common/loader.dart';
import 'package:social_app/features/timeline/screens/widgets/comment.dart';
import 'package:social_app/features/timeline/screens/widgets/post.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/theme/pallete.dart';

import '../../../core/utils.dart';
import '../controller/timeline_controller.dart';

class PostScreen extends ConsumerWidget {
  final String id;

  const PostScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("rebuild");
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
        ),
        body: SafeArea(
            child: ref.watch(postByIdProvider(id)).when(
                  data: (PostModel post) {
                    return ref.watch(commentsByPostIdProvider(post.id)).when(
                          data: (comments) {
                            return Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * getPostPadding(post.content) *1.2,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    return Comment(comment: comments[index]);
                                  },
                                ),
                                Container(
                                  color: Palette.background,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Post(
                                        path: "timeline",
                                        post: post,
                                      ),
                                      const Divider(
                                        color: Palette.surface,
                                        thickness: 2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          loading: () => const Center(child: Loader()),
                          error: (error, stack) => const Center(
                            child: Text("Error"),
                          ),
                        );
                  },
                  loading: () => const Center(child: Loader()),
                  error: (error, stack) => const Center(
                    child: Text("Error"),
                  ),
                )));
  }
}



  // return Scaffold(
  //       appBar: AppBar(
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //       ),
  //       body: SafeArea(
  //           child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             ref.watch(postByIdProvider(id)).when(
  //                   data: (PostModel post) {
  //                     return Column(
  //                       children: [
  //                         Post(
  //                           post: post,
  //                         ),
  //                         Divider(
  //                           color: Palette.surface,
  //                           thickness: 2,
  //                         ),
  //                         ref.watch(commentsByPostIdProvider(post.id)).when(
  //                               data: (comments) {
  //                                 return ListView.builder(
  //                                   shrinkWrap: true,
  //                                   itemCount: comments.length,
  //                                   itemBuilder: (context, index) {
  //                                     return Comment(comment: comments[index]);
  //                                   },
  //                                 );
  //                               },
  //                               loading: () => const Center(child: Loader()),
  //                               error: (error, stack) => const Center(
  //                                 child: Text("Error"),
  //                               ),
  //                             ),
  //                       ],
  //                     );
  //                   },
  //                   loading: () => const Center(child: Loader()),
  //                   error: (error, stack) => const Center(
  //                     child: Text("Error"),
  //                   ),
  //                 ),
  //           ],
  //         ),
  //       )));