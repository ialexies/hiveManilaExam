

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String userName;
  final String displayName;
  final String firstName;
  final String lastName;
  final String bio;
  final String email;
  final String age;
  final String gender;
  final String profilePhoto;
  final String phoneNumber;
  final String loginType;

  User({
    this.id,
    this.userName,
    this.displayName,
    this.firstName,
    this.lastName,
    this.bio,
    this.email, 
    this.age,
    this.gender,
    this.profilePhoto,
    this.phoneNumber,
    this.loginType,
  });




  
  factory User.fromDocument(DocumentSnapshot doc){



    return User(
      id: doc['id'],
      email: doc['email'],
      userName: doc['username'],
      profilePhoto: doc['profilePhoto'],
		  displayName: doc['displayName'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      // bio: doc['bio'],
      
    );
  }

  factory User.fromNewRegister(userInfo){
    return User(
      email: userInfo['email'],
      firstName: userInfo['firstName'],
      lastName: userInfo['lastName'],
      profilePhoto: userInfo['photo'],
    );    

  }


  // factory User.fromGoogle(DocumentSnapshot doc){

  //   return User(
  //     id: doc['id'],
  //     email: doc['email'],
  //     userName: doc['username'],
  //     profilePhoto: doc['photoUrl'],
	// 	      displayName: doc['displayName'],
  //     // bio: doc['bio'],
      
  //   );
  // }


  // factory User.fromFb(DocumentSnapshot doc){

  //   return User(
  //     id: doc['id'],
  //     email: doc['email'],
  //     firstName: doc['firstName'],
  //     lastName: doc['lastName'],
  //     // profilePhoto: doc['picture']['url'],
	// 	      displayName: doc['displayName'],
  //     // bio: doc['bio'],
      
  //   );

  // }
  


}