

import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
   String uid;
   String title;
   String ownerId;
   String username;
   dynamic likes;
   String imgUrl;
   int index;

  Post({
    this.uid,
    this.title,
    this.ownerId,
    this.username,
    this.likes,
    this.imgUrl,
    this.index
  });

  	Map<String, dynamic> toMap(){
		var map = Map<String, dynamic>();
		if (uid !=null){
			map['id'] = uid;
		}
		map['title']=title;
		map['ownerId']=ownerId;
		map['username']=username;
		map['likes']=likes;
    map['imgUrl']=imgUrl;
		return map;
} 

    factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      uid: doc['id'],
      title: doc['title'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      likes: doc['likes'],
      imgUrl: doc['imgUrl'],
      
    );
  }


}