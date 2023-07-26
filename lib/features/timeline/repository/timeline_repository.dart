import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_app/core/providers/firestore_providers.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/post_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/types/failure.dart';
import '../../../core/types/type_defs.dart';

final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return TimelineRepository(firestore: firestore);
});

class TimelineRepository {
  final FirebaseFirestore _firestore;
  TimelineRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).delete();

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(-1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void likePost(PostModel post, String userId) async {
    if (post.likes.contains(userId)) {
      await _posts.doc(post.id).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      await _posts.doc(post.id).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvoteComment(CommentModel comment, String userId) async {
    if (comment.upvotes.contains(userId)) {
      await _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (comment.downvotes.contains(userId)) {
      await _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      return await _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void upvoteComment(CommentModel comment, String userId) async {
    if (comment.downvotes.contains(userId)) {
      await _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (comment.upvotes.contains(userId)) {
      await _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      return await _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<List<PostModel>> fetchPosts() {
    return _posts.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<PostModel>> fetchPostsByUserId(String userId) {
    return _posts
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<CommentModel>> fetchCommentsByPostId(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<PostModel> fetchPostById(String postId) {
    final doc = _posts.doc(postId).get();
    return doc.asStream().map((snapshot) {
      return PostModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }
}
