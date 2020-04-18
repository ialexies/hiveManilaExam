import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:fluttershare/pages/home.dart';
import 'home.dart';
// import 'package:fluttershare/widgets/header.dart';
import 'package:hiveManilaExam/models/posts.dart';

import 'package:hiveManilaExam/widgets/progress.dart';

class PostScreen extends StatefulWidget {
  final String userEmail;
  final String postId;

  PostScreen({this.userEmail, this.postId});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController updateTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: postsRef
            .document(currentUser.email)
            .collection('userPosts')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Widget> listPosts = [];
          snapshot.data.documents.forEach((doc) {
            listPosts.add(
              Stack(
                children: <Widget>[
                  Image.network(
                    Post.fromDocument(doc).imgUrl,
                    fit: BoxFit.cover,
                    // height: double.infinity,
                    // width: double.infinity,
                    // alignment: Alignment.center,
                  ),
                  AppBar(
                    title: Text(Post.fromDocument(doc).title),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            buildShowDialog(Post.fromDocument(doc).uid);
                            updateTitleController.text=Post.fromDocument(doc).title;
                            print('edit ${Post.fromDocument(doc).uid}');
                          }),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            postsRef
                                .document(currentUser.email)
                                .collection('userPosts')
                                .document(Post.fromDocument(doc).uid)
                                .delete();

                            print('delete ${Post.fromDocument(doc).uid}');
                          }),
                    ],
                  ),
                  Positioned(
                      bottom: 30,
                      left: 30,
                      child: Column(
                        children: <Widget>[
                          Text(
                            Post.fromDocument(doc).title.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                              'Posted by ${Post.fromDocument(doc).username.toUpperCase()}',
                              textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white,),
                          ),
                          Text(
                              '${Post.fromDocument(doc).likes.length} Likes',
                              textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white,),
                          ),
                        ],
                      ))
                ],
              ),

              //  Text( Post.fromDocument(doc).imgUrl)
              //  Post.fromDocument(doc)
            );
          });
          return ListView(
            children: listPosts,
          );
        });
  }

  Future buildShowDialog(String doc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Title'),
            content: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: updateTitleController,
                          decoration: InputDecoration(
                            hintText: "Update Title",
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  updateTitleController.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            setState(() {
                              // imageDetails[index].title = updateTitleController.text;

                              postsRef
                                  .document(currentUser.email)
                                  .collection('userPosts')
                                  .document(doc)
                                  .updateData(
                                      {"title": updateTitleController.text});
                              // .setData('title':'updatedTitle');

                              updateTitleController.text;
                              updateTitleController.clear();
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
