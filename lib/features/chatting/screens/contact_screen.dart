import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import 'Search_screen..dart';
import 'chatting_screen.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});
  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        centerTitle: true,
        backgroundColor: Palette.background,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text(
                    "No Chats Available !",
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            // leading: ClipRRect(
                            //   borderRadius: BorderRadius.circular(80),
                            //   child: CachedNetworkImage(
                            //     imageUrl:friend['profilePic'],
                            //     placeholder: (conteext,url)=>CircularProgressIndicator(),
                            //     errorWidget: (context,url,error)=>Icon(Icons.error,),
                            //     height: 50,
                            //   ),
                            // ),
                            leading: InkWell(
                              onTap: () {
                                context.go('/contact/profile/${friend['uid']}');
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/images/profile.jpg"),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            title: Text(
                              friend['name'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              "$lastMsg",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    currentUser: user,
                                    friendId: friend['uid'],
                                    friendName: friend['name'],
                                    friendImage: friend['profilePic'],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const LinearProgressIndicator();
                      },
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.primary,
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchScreen(user)));
        },
      ),
    );
  }
}
