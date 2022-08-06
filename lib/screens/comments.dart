// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/contants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentsScreen extends StatefulWidget {
  final Map data;
  const CommentsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://cdn1-m.zahratalkhaleej.ae/store/archive/image/2020/11/4/813126b3-4c9d-4a7b-b8d9-83f46749fa26.jpg?format=jpg&preset=w1900"),
                      radius: 26,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("USERNAME",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(
                            width: 11,
                          ),
                          Text("nice pic ♥♥",
                              style: const TextStyle(fontSize: 16))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("12/12/2012",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ))
                    ],
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(125, 78, 91, 110),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userData!.profileImg),
                    radius: 26,
                  ),
                ),
                Expanded(
                  child: TextField(
                      controller: commentController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                          hintText: "Comment as  ${userData.username}  ",
                          suffixIcon: IconButton(
                              onPressed: () async {
                                String commentId = const Uuid().v1();
                                await FirebaseFirestore.instance
                                    .collection("postSSS")
                                    .doc(widget.data["postId"])
                                    .collection("commentSSS")
                                    .doc(commentId)
                                    .set({
                                  "profilePic": userData.profileImg,
                                  "username": userData.username,
                                  "textComment": commentController.text,
                                  "dataPublished": DateTime.now(),
                                  "uid": userData.uid,
                                  "commentId": commentId
                                });

                                commentController.clear();
                              },
                              icon: Icon(Icons.send)))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
