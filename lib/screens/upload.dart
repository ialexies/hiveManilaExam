import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiveManilaExam/models/posts.dart';
import '../models/users.dart';
import '../screens/home.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

import 'home.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // File file;
  List<Asset> images = List<Asset>();
  List<Post> imageDetails = [];
  bool isUploading = false;
  final _formKey = GlobalKey<FormState>();
  bool isUploaded=false;
  String _error = 'No Error Dectected';
  List<String> imageUrls = <String>[];
  
  TextEditingController updateTitleController = TextEditingController();

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Stack(
                children: <Widget>[
                  AssetThumb(
                    asset: asset,
                    width: 600,
                    height: 600,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      BottomAppBar(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      buildShowDialog(index);
                                    });
                                  }),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 5,
                            ),
                            Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.delete), 
                                  onPressed: null,
                                  // onPressed: (){
                                  //   print('fdfdf');
                                  //   setState(() {
                                  //     images.remove(images[index]);
                                  //     // images.remove(index);
                                  //     imageDetails.remove(images[index]);
                                  //   });
                                  // },
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        imageDetails[index].title,
                        style: Theme.of(context).textTheme.headline,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  deleteImageInList(){}
  Future buildShowDialog(int index) {
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
                              imageDetails[index].title = updateTitleController.text;

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

  Future<void> loadAssets() async {
    images = [];
    imageDetails = [];
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    isUploaded=false;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "Select Photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });

    for (var x = 0; x < images.length; x++) {
      imageDetails.add(Post(
        index: x,
        uid: Uuid().v4(),
        title: '',
      ));
    }

    print(imageDetails.toString());
  }

  Future<String> uploadImage()async{

 

    for (var i = 0; i < imageDetails.length; i++) {
      StorageUploadTask uploadTask = storageRef.child("post_${imageDetails[i].uid}.jpg")
        .putData((await  images[i].getByteData()).buffer.asUint8List());
      StorageTaskSnapshot storageSnap =  await uploadTask.onComplete; //FIRStorageTaskSnapshot represents an immutable view of a task.
      String downloadUrl = await storageSnap.ref.getDownloadURL();

      imageDetails[i].imgUrl=downloadUrl;
                                    imageDetails[i].username = currentUser.id;
                              imageDetails[i].ownerId = currentUser.email;
                              imageDetails[i].likes = [];
                              imageDetails[i].username = currentUser.firstName;
                         
    }


    createPostInFireStore();
    // return downloadUrl;
  }


  createPostInFireStore(){
   
    var dbBatch = Firestore.instance.batch();
    int count = 0;

    if (imageDetails != []) {
      var dbBatch = Firestore.instance.batch();
      imageDetails.forEach((x) async{

        Post toUpload = x;
        //add to storage and returns a media url
        // String mediaUrl = await uploadImage(images[count],x.uid);

        // toUpload.imgUrl= await uploadImage(images[count],x.uid);

        // Add to firestore
        
        dbBatch.setData(
            postsRef
                .document(currentUser.email)
                .collection("userPosts")
                .document(x.uid),
            toUpload.toMap());
        // if(imageDetails.length==x){
        //    dbBatch.commit();
        // }
      });
      
      // count=count+1;
      dbBatch.commit();

      setState(() {
        images=[];
        imageDetails=[];
      });
      
    }

     setState(() {
        isUploading=false;
        isUploaded=true;
      });

  }


  handleSubmit() async {
    
    setState(() {
      isUploading = true;
    });

      uploadImage();
 
      
    //  createPostInFireStore();

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
          title: const Text(
            'Upload Images',
          ),
          actions: <Widget>[
            RaisedButton(child: Text('Upload'), onPressed: handleSubmit),
          ],
        ),
        body: Column(
          children: <Widget>[
            isUploading ? LinearProgressIndicator() : SizedBox(height: 0,),
            isUploaded? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Photos has been uploaded',textAlign: TextAlign.center, style: Theme.of(context).textTheme.display1,),
                ),
              ],
            ):SizedBox(height: 0,),
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: loadAssets,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: new BottomAppBar(
          color: Colors.white,
          child: new Row(),
        ),
      ),
    );
  }
}
