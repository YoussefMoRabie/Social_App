import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../theme/pallete.dart';
import 'chatting_screen.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No User Found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['name'] != widget.user.name) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

//   return searchResult;
// }

  // void onSearch()async{
  //  UserModel m= UserModel(name: 'Wedayn', profilePic: '', uid: '099', score: 0, followers: [], following: [], key: '', validityOfKey: 0);
  //  setState(() {
  //    searchResult.add(m.toMap());
  //       isLoading = true;
  //  });

  //   // setState(() {
  //   //   searchResult = [];
  //   //   isLoading = true;
  //   // });

  //   await FirebaseFirestore.instance.collection('users').where("email",isEqualTo: searchController.text).get().then((value){
  //      if(value.docs.length < 1){
  //        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User Found")));
  //           setState(() {
  //     isLoading = false;
  //   });
  //   return;
  //      }
  //      value.docs.forEach((user) {
  //         if(user.data()['uid'] != widget.user.uid){
  //              searchResult.add(user.data());
  //         }
  //       });
  //    setState(() {
  //     isLoading = false;
  //   });
  //   });
  // }

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
                        hintText: "type name....",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              IconButton(
                  color: Palette.primary,
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                            // child: Image.network(searchResult[index]['profilePic']),
                            child: const Image(
                          image: AssetImage("assets/images/profile.jpg"),
                          fit: BoxFit.cover,
                        )),
                        title: Text(searchResult[index]['name']),
                        subtitle: Text(searchResult[index]['name']),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.text = "";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          currentUser: widget.user,
                                          friendId: searchResult[index]['uid'],
                                          friendName: searchResult[index]
                                              ['name'],
                                          friendImage: searchResult[index]
                                              ['profilePic'])));
                            },
                            icon: Icon(Icons.message)),
                      );
                    }))
          else if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
