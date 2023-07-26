import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/timeline/repository/timeline_repository.dart';
import 'package:social_app/features/timeline/screens/widgets/post.dart';
import 'package:social_app/models/post_model.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../models/comment_model.dart';
import '../../auth/controller/auth_controller.dart';

final timelineControllerProvider =
    StateNotifierProvider<TimelineController, bool>((ref) {
  final timelineRepository = ref.watch(timelineRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return TimelineController(
    timelineRepository: timelineRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final postsProvider = StreamProvider<List<PostModel>>((ref) {
  final controller = ref.watch(timelineControllerProvider.notifier);

  return controller.fetchPosts();
});

final commentsByPostIdProvider =
    StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  final controller = ref.watch(timelineControllerProvider.notifier);
  return controller.fetchCommentsByPostId(postId);
});

final postsByUserIdProvider =
    StreamProvider.family<List<PostModel>, String>((ref, userId) {
  final controller = ref.watch(timelineControllerProvider.notifier);
  return controller.fetchPostsByUserId(userId);
});

final postByIdProvider =
    StreamProvider.family<PostModel, String>((ref, postId) {
  final controller = ref.watch(timelineControllerProvider.notifier);
  return controller.fetchPostById(postId);
});

class TimelineController extends StateNotifier<bool> {
  final TimelineRepository _timelineRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  TimelineController({
    required TimelineRepository timelineRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _timelineRepository = timelineRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void addPost({
    required BuildContext context,
    required String postText,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final userId = user!.uid;
    final postId = Uuid().v4();
    final post = PostModel(
      id: postId,
      content: postText,
      createdAt: DateTime.now().toString(),
      userId: userId,
      likes: [],
      commentCount: 0,
    );

    final res = await _timelineRepository.addPost(post);

    state = false;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.message),
        ),
      ),
      (r) => context.pop(),
    );
  }

  void deletePost({
    required BuildContext context,
    required PostModel post,
  }) async {
    state = true;
    final res = await _timelineRepository.deletePost(post);
    state = false;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.message),
        ),
      ),
      (r) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Post Deleted"),
        ),
      ),
    );
  }

  void addComment({
    required BuildContext context,
    required String postId,
    required File? file,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final userId = user!.uid;
    final username = user!.name;
    final commentId = Uuid().v4();
    final imageRes = await _storageRepository.storeFile(
      path: 'comments/$postId',
      id: postId,
      file: file,
    );
    final imageUrl = imageRes.fold(
      (l) => "",
      (r) => r,
    );
    final comment = CommentModel(
      id: commentId,
      username: username,
      imageUrl: imageUrl,
      createdAt: DateTime.now().toString(),
      userId: userId,
      postId: postId,
      upvotes: [],
      downvotes: [],
    );

    final res = await _timelineRepository.addComment(comment);

    state = false;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.message),
        ),
      ),
      (r) => "",
    );
  }

  void deleteComment({
    required BuildContext context,
    required CommentModel comment,
  }) async {
    state = true;
    final res = await _timelineRepository.deleteComment(comment);
    state = false;
    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.message),
        ),
      ),
      (r) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Comment Deleted"),
        ),
      ),
    );
  }

  void likePost({
    required BuildContext context,
    required PostModel post,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final userId = user!.uid;
    _timelineRepository.likePost(post, userId);
    state = false;
  }

  void upvoteComment({
    required BuildContext context,
    required CommentModel comment,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final userId = user!.uid;
    _timelineRepository.upvoteComment(comment, userId);
    state = false;
  }

  void downvoteComment({
    required BuildContext context,
    required CommentModel comment,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final userId = user!.uid;
    _timelineRepository.downvoteComment(comment, userId);
    state = false;
  }

  Stream<List<PostModel>> fetchPosts() {
    final posts = _timelineRepository.fetchPosts();
    Future.delayed(const Duration(seconds: 5), () {});
    return posts;
  }

  Stream<List<CommentModel>> fetchCommentsByPostId(String postId) {
    final comments = _timelineRepository.fetchCommentsByPostId(postId);
    return comments;
  }

  Stream<List<PostModel>> fetchPostsByUserId(String userId) {
    final posts = _timelineRepository.fetchPostsByUserId(userId);
    return posts;
  }

  Stream<PostModel> fetchPostById(String postId) {
    final post = _timelineRepository.fetchPostById(postId);
    return post;
  }
}
