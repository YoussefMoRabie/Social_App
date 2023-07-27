import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import 'Search_screen..dart';
import 'chatting_screen.dart';



class ContactScreen extends ConsumerStatefulWidget {


  ContactScreen({super.key});
  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends  ConsumerState<ContactScreen>{
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
        centerTitle: true,
        backgroundColor: Palette.background,
        
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('messages').snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length < 1){
              return Center(
                child: Text("No Chats Available !",),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                var friendId = snapshot.data.docs[index].id;
                var lastMsg = snapshot.data.docs[index]['last_msg'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                  builder: (context,AsyncSnapshot asyncSnapshot){
                    if(asyncSnapshot.hasData){
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
                       leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(
                            image: AssetImage("assets/images/profile.jpg"),
                            fit: BoxFit.cover,
                          )),
                        title: Text(friend['name'],style: TextStyle(fontSize: 20),),
                        subtitle: Container(
                          child: Text("$lastMsg",style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                            currentUser: user,
                             friendId: friend['uid'],
                              friendName: friend['name'],
                               friendImage: friend['profilePic'])));
                        },
                      );
                    }
                    return LinearProgressIndicator();
                  },

                );
              });
          }
          return Center(child: CircularProgressIndicator(),);
        }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.primary,
        child: Icon(Icons.search),
        onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(user)));
        },
      ),
      
    );
  }
}