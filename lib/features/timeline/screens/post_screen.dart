import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerWidget {
  final String id;

  const PostScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Center(
        child: Text('Post number $id'),
      ),
    );
  }
}
