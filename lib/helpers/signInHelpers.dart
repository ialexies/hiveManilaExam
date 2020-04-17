// import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
bool isAuth;
final FacebookLogin facebookSignIn = new FacebookLogin();

class SignInHelper{
   signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    await facebookSignIn.logOut();
  }

}
