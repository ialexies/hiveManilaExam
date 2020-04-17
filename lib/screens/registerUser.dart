import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiveManilaExam/models/users.dart';
import 'package:hiveManilaExam/screens/home.dart';

class RegisterUser extends StatefulWidget {
  String loginType;
  Map<String, String> userInfo;
  RegisterUser({this.userInfo});
  final usersRef = Firestore.instance.collection('users');

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String lastName;

  // _RegisterUserState(this.user);

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register Account"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.cancel), onPressed: null,),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.userInfo["photo"]),
                          radius: 75,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.userInfo["email"],
                          style: Theme.of(context).textTheme.title,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            TextFormField(
                                decoration: buildInputDecoration(
                                    hintText: "First Name"),
                                textAlign: TextAlign.center,
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Enter First Name";
                                  } else if (val.length > 20) {
                                    return "First Name is too long. . . Seriously!?";
                                  } else if (val.length < 2) {
                                    return "Too short! . . There's no name like that!";
                                  }
                                },
                                autovalidate: true,
                                onSaved: (val) {
                                  firstName = val.toString();
                                  print(firstName);
                                }),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration:
                                  buildInputDecoration(hintText: "Last Name"),
                              textAlign: TextAlign.center,
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Enter Last Name";
                                } else if (val.length > 20) {
                                  return "Last Name is too long. . . Seriously!?";
                                } else if (val.length < 2) {
                                  return "Too short! . . There's no name like that!";
                                }
                              },
                              autovalidate: true,
                              onSaved: (val) {
                                lastName = val.toString();
                                print(lastName);
                              },
                            ),
                            SizedBox(height: 20),
                            ButtonTheme(
                              minWidth: 150,
                              height: 50,
                              splashColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(.5),
                                  width: 2,
                                ),
                              ),
                              child: RaisedButton.icon(
                                icon: Icon(Icons.save,
                                    color: Theme.of(context).primaryColorLight),
                                onPressed: () => createUser(),
                                label: Text(
                                  'Register',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                                color: Theme.of(context).accentColor,
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration({
    String hintText,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  createUser() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      Map userInfo = {
        "email": widget.userInfo["email"],
        "firstName": firstName,
        "lastName": lastName,
        "photo": widget.userInfo["photo"]
      };

      usersRef.document(userInfo["email"]).setData({
        "email": userInfo["email"],
        "firstName": userInfo["firstName"],
        "lastName": userInfo["lastName"],
        "profilePhoto": userInfo["photo"],
      }).then((val) {
        SnackBar snackBar = SnackBar(content: Text("Welcome $firstName"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context, userInfo);
        });
      }).catchError((val){
        print('error on adding user $val');
      });
    }
  }
}
