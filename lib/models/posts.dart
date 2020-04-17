

import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String uid;
  final String title;
  final int index;


  Post({
    this.uid,
    this.title,
    this.index
  });

  	Map<String, dynamic> toMap(){
		var map = Map<String, dynamic>();
		if (uid !=null){
			map['id'] = uid;
		}
		map['title']=title;
		return map;
} 

}