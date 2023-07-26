
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../theme/pallete.dart';
import 'chatting_screen.dart';


class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult =[];
  bool isLoading = false;

   
// Future<List<Map>> accessUserData() async {
//    setState(() {
//       searchResult = [];
//       isLoading = true;
//     });
 
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance.collection('users').get();
//     if (snapshot.docs.isNotEmpty) {
//       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
//         Map<String, dynamic> userData = doc.data();
//         UserModel user = UserModel(
//           name: userData['name'],
//           profilePic: userData['profilePic'],
//           uid: userData['uid'],
//           score: userData['score'],
//         );
//       searchResult.add(userData);
//       }
//     } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User Found")));
//             setState(() {
//       isLoading = false;
//     });
//     }
  
//   return searchResult;
// }

  void onSearch()async{
   UserModel m= UserModel(name: 'Wedayn', profilePic: '', uid: '099', score: 0, followers: [], following: [], key: '', validityOfKey: 0);
   setState(() {
     searchResult.add(m.toMap());
        isLoading = true;
   });
   
    // setState(() {
    //   searchResult = [];
    //   isLoading = true;
    // });
    
     
    await FirebaseFirestore.instance.collection('users').where("email",isEqualTo: searchController.text).get().then((value){
       if(value.docs.length < 1){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User Found")));
            setState(() {
      isLoading = false;
    });
    return;
       }
       value.docs.forEach((user) {
          if(user.data()['uid'] != widget.user.uid){
               searchResult.add(user.data());
          }
        });
     setState(() {
      isLoading = false;
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text("Search your Friend"),
      ),
      body: Column(
        children: [
           Row(
             children: [
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: TextField(
                     controller: searchController,
                     decoration: InputDecoration(
                       hintText: "type username....",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10)
                       )
                     ),
                   ),
                 ),
               ),
               IconButton(
                color: Palette.primary,
                onPressed: (){
                  onSearch();
               }, icon: Icon(Icons.search))
             ],
           ),
           if(searchResult.length > 0)
              Expanded(child: ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(searchResult[index]['profilePic']),
                    ),
                    title: Text(searchResult[index]['name']),
                    subtitle: Text(searchResult[index]['name']),
                    trailing: IconButton(onPressed: (){
                        setState(() {
                          searchController.text = "";
                        });
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                             currentUser: widget.user, 
                             friendId: searchResult[index]['uid'],
                              friendName: searchResult[index]['name'],
                               friendImage: searchResult[index]['profilePic'])));
                    }, icon: Icon(Icons.message)),
                  );
                }))
           else if(isLoading == true)
              Center(child: CircularProgressIndicator(),)
        ],
      ),
      
    );
  }
}